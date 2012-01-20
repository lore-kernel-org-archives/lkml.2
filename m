Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2ATNAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:00:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34122 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751570Ab2ATNAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:00:16 -0500
Message-ID: <1327064413.6176.14.camel@joe2Laptop>
Subject: Re: checkpatch regression: error on #define pr_fmt(fmt)
 KBUILD_MODNAME ": " fmt
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Fri, 20 Jan 2012 05:00:13 -0800
In-Reply-To: <CAAq6er0eXaG7pShVAtbSycs0NiqUbmj99P-Re_N3vWRvym=+5g@mail.gmail.com>
References: <1326316354.6774.12.camel@joe2Laptop>
	 <CAAq6er0eXaG7pShVAtbSycs0NiqUbmj99P-Re_N3vWRvym=+5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 11:53 +0000, Andy Whitcroft wrote:
> On Wed, Jan 11, 2012 at 9:12 PM, Joe Perches <joe@perches.com> wrote:
> > Current checkpatch gives:
> > ERROR: Macros with complex values should be enclosed in parenthesis
> > #18: FILE: net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:18:
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
[]
> Does the below version work better for you:
>     http://people.canonical.com/~apw/checkpatch/checkpatch-next.pl

Diff is basically:

+                       # Flatten any obvious string concatentation.
+                       while ($dstat =~ s/("X*")\s*$Ident/$1/ ||
+                              $dstat =~ s/$Ident\s*("X*")/$1/)
+                       {
+                       }

Yes, that works and is appropriate.



