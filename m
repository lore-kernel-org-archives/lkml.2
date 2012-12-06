Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945933Ab2LFQfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:35:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:52485 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945920Ab2LFQfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:35:00 -0500
Date: Thu, 6 Dec 2012 11:34:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Borislav Petkov <bp@alien8.de>
CC: <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        <rob@landley.net>
Subject: Re: [PATCH] x86: ptrace.c only needs export.h and not the full
 module.h
Message-ID: <20121206163439.GA10797@windriver.com>
References: <1354793622-8497-1-git-send-email-paul.gortmaker@windriver.com>
 <20121206161725.GA10351@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121206161725.GA10351@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH] x86: ptrace.c only needs export.h and not the full module.h] On 06/12/2012 (Thu 17:17) Borislav Petkov wrote:

> On Thu, Dec 06, 2012 at 06:33:42AM -0500, Paul Gortmaker wrote:
> > Commit cb57a2b4cff7edf2a4e32c0163200e9434807e0a ("x86-32: Export
> > kernel_stack_pointer() for modules") added an include of the
> > module.h header in conjunction with adding an EXPORT_SYMBOL_GPL
> > of kernel_stack_pointer.
> > 
> > But module.h should be avoided for simple exports, since it in turn
> > includes the world.  Swap the module.h for export.h instead.
> 
> If this is the preferred include for EXPORT_SYMBOL* stuff now, maybe we
> should hold this down somewhere in writing or add it to checkpatch?

Good point.  Fixed below.

Thanks,
Paul.


>From 6d7ea827572bf4a5b7c0bd6ae3f12f5be0a7c7c2 Mon Sep 17 00:00:00 2001
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 6 Dec 2012 11:26:53 -0500
Subject: [PATCH] DocBook: update EXPORT_SYMBOL entry to point at export.h

Previously we used to get EXPORT_SYMBOL and friends from
module.h but we moved away from that since module.h largely
includes the entire header space one way or another.

As most users just wanted the simple export related macros,
they were spun off into a separate new header -- export.h
Update the docs to reflect that.

Suggested-by: Borislav Petkov <bp@alien8.de>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/DocBook/kernel-hacking.tmpl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index eee7142..a23bc37 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -945,7 +945,7 @@ printk(KERN_INFO "my ip: %pI4\n", &amp;ipaddress);
 
   <sect1 id="sym-exportsymbols">
    <title><function>EXPORT_SYMBOL()</function>
-    <filename class="headerfile">include/linux/module.h</filename></title>
+    <filename class="headerfile">include/linux/export.h</filename></title>
 
    <para>
     This is the classic method of exporting a symbol: dynamically
@@ -955,7 +955,7 @@ printk(KERN_INFO "my ip: %pI4\n", &amp;ipaddress);
 
   <sect1 id="sym-exportsymbols-gpl">
    <title><function>EXPORT_SYMBOL_GPL()</function>
-    <filename class="headerfile">include/linux/module.h</filename></title>
+    <filename class="headerfile">include/linux/export.h</filename></title>
 
    <para>
     Similar to <function>EXPORT_SYMBOL()</function> except that the
-- 
1.8.0

