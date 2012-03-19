Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2CSMhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:37:05 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:23910 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2CSMhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:37:03 -0400
Date: Mon, 19 Mar 2012 14:36:47 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xz: make use of BCJ filter also for 32-bit x86 kernel
Message-ID: <20120319143647.3cf46ed2@tukaani.org>
In-Reply-To: <4F66F6A302000078000792FF@nat28.tlf.novell.com>
References: <4F621C930200007800078B9E@nat28.tlf.novell.com>
	<20120316204737.23aacd2b@tukaani.org>
	<4F66F6A302000078000792FF@nat28.tlf.novell.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-19 Jan Beulich wrote:
> >>> On 16.03.12 at 19:47, Lasse Collin <lasse.collin@tukaani.org>
> >>> wrote:
> > On 2012-03-15 Jan Beulich wrote:
> >> The ARCH value for 32-bit x86 is not x86, but i?86.
> > 
> > Thanks for noticing this. Is ARCH even the correct variable to use?
> > Maybe SRCARCH would be better. Then it would be enough to test for
> > x86, if I understand the toplevel Makefile correctly.
> 
> Yes, that might be even better (albeit requiring adjustment of the
> script should the naming in the source tree ever change again,
> whereas the ARCH values are supposedly stable).

I think I will go with SRCARCH then. The directory names don't change so
often.

Could you quickly check if the following is OK? It works on x86-64.

diff --git a/scripts/xz_wrap.sh b/scripts/xz_wrap.sh
--- a/scripts/xz_wrap.sh
+++ b/scripts/xz_wrap.sh
@@ -12,8 +12,8 @@
 BCJ=
 LZMA2OPTS=
 
-case $ARCH in
-	x86|x86_64)     BCJ=--x86 ;;
+case $SRCARCH in
+	x86)            BCJ=--x86 ;;
 	powerpc)        BCJ=--powerpc ;;
 	ia64)           BCJ=--ia64; LZMA2OPTS=pb=4 ;;
 	arm)            BCJ=--arm ;;

> Will you get a patch to Linus then to fix all of these in 3.4?

I will. Should the fix be included in the stable trees too? I'm not sure
if this is acceptable under the stable kernel rules. At least someone
should test it on SPARC first.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
