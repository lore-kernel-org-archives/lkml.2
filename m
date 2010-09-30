Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab0I3Luf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:50:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36993 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab0I3Lud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:50:33 -0400
Date: Thu, 30 Sep 2010 12:50:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
        mattst88@gmail.com, torvalds@linux-foundation.org,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: switch osf_sigprocmask() to use of
 sigprocmask()
Message-ID: <20100930115030.GL19804@ZenIV.linux.org.uk>
References: <E1OzvxM-0002ng-B5@ZenIV.linux.org.uk>
 <4CA1B7DF.10202@orcon.net.nz>
 <20100929010738.GJ19804@ZenIV.linux.org.uk>
 <4CA43E95.5040301@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA43E95.5040301@orcon.net.nz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 08:39:01PM +1300, Michael Cree wrote:
> It appears to be worse than that.  It introduces a regression.  On
> boot up on a Compaq Alpha XP1000 the system appears to freeze at the
> point of mounting swap.  It eventually resumes after almost three
> minutes and continues to boot.


diff --git a/arch/alpha/kernel/signal.c b/arch/alpha/kernel/signal.c
index 779780a..f7f054d 100644
--- a/arch/alpha/kernel/signal.c
+++ b/arch/alpha/kernel/signal.c
@@ -48,7 +48,7 @@ SYSCALL_DEFINE2(osf_sigprocmask, int, how, unsigned long, newmask)
 	sigset_t mask;
 	unsigned long res;
 
-	siginitset(&mask, newmask & ~_BLOCKABLE);
+	siginitset(&mask, newmask & _BLOCKABLE);
 	res = siprocmask(how, &mask, &oldmask);
 	if (!res) {
 		force_successful_syscall_return();
