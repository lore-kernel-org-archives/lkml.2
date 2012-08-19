Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2HSIxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:53:10 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37268 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab2HSIxG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:2>);
	Sun, 19 Aug 2012 04:53:06 -0400
Message-Id: <5030B77E020000780008A233@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Sun, 19 Aug 2012 09:53:02 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <andi@firstfloor.org>, <ak@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Cc: <x86@kernel.org>, <akpm@linux-foundation.org>, <jmario@redhat.com>,
        <rusty@rustcorp.com.au>, <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 59/74] lto: Handle LTO common symbols in module
 loader
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
 <1345345030-22211-60-git-send-email-andi@firstfloor.org>
In-Reply-To: <1345345030-22211-60-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 08/19/12 4:59 AM >>>
>@@ -1904,6 +1904,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 >
>        switch (sym[i].st_shndx) {
>        case SHN_COMMON:
>+            /* Ignore common symbols */
>+            if (!strncmp(name, "__gnu_lto", 9))
>+                break;
>+
>            /* We compiled with -fno-common.  These are not
>               supposed to happen.  */
>            pr_debug("Common symbol: %s\n", name);

I think it is dangerous to just match the start of the symbol name here -
this may in the future well lead to ignoring symbols we shouldn't be
ignoring.

Also I would think the added comment ought to say "Ignore LTO symbols."
Otherwise its sort of contradicting the purpose of the case being handled
here.

Jan

