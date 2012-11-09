Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2KIKBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 05:01:02 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:33119 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2KIKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 05:00:57 -0500
MIME-Version: 1.0
In-Reply-To: <20121109144307.a2a77fcdab8aaa262bf54cd9@canb.auug.org.au>
References: <20121109144307.a2a77fcdab8aaa262bf54cd9@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Nov 2012 10:00:34 +0000
X-Google-Sender-Auth: UNhBamRE_7pF58QTYeJdIgcxtzQ
Message-ID: <CACxGe6uLfdYohqFQLGV3MqJxNZK7uKKvg6JuP8UBG2HfaXq6XQ@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the akpm tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 3:43 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> After merging the akpm tree, today's linux-next build (powerpc
> allnoconfig - among others) produced this warning:
>
> drivers/of/fdt.c: In function 'of_scan_flat_dt':
> drivers/of/fdt.c:490:10: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]
>
> Introduced by commit "drivers/of/fdt.c: re-use kernel's kbasename()".

Adding this hunk to the patch fixes it:

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 91a375f..738228f 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -459,7 +459,7 @@ int __init of_scan_flat_dt(int (*it)(unsigned long node,

        do {
                u32 tag = be32_to_cpup((__be32 *)p);
-               char *pathp;
+               const char *pathp;

                p += 4;
                if (tag == OF_DT_END_NODE) {

g.
