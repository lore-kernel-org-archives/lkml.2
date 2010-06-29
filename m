Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0F2HH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:07:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35850 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0F2HHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fKRiAr4vjIz3G0oLHBvyk3sCUKfiQD4WVPNmtNsWFd+fsWQeTuWvpKvRWg+OsLZwAd
         2bH/P9X9fAJMfPj0A/+LfNloOvpuWCGTVIrXSuysYB9TdwjmXREXEbF+UhBIfTbLLhCM
         aZEyn+1a+ZOrcbGGt803ht7mAyGOlHZm2naiw=
Date: Tue, 29 Jun 2010 00:07:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?=C9ric?= Piel <E.A.B.Piel@tudelft.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Regression 2.6.35-rc1?] Sysrq works too well (no need of alt)
Message-ID: <20100629070717.GD19712@core.coreip.homeip.net>
References: <4C0E0E51.8050709@tudelft.nl>
 <201006192316.32360.rjw@sisk.pl>
 <4C1D4FA6.6030607@tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C1D4FA6.6030607@tudelft.nl>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 01:15:50AM +0200, Éric Piel wrote:
> Op 19-06-10 23:16, Rafael J. Wysocki schreef:
> > On Tuesday, June 08, 2010, Éric Piel wrote:
> >> Hello,
> >> I haven't investigated much yet, but I have the feeling that since
> >> 2.6.35-rc1 my "Print Screen/SysRq" key works only as SysRq: if I press
> >> it (normally assigned to take screenshot in gnome), nothing happens (no
> >> input event received in userspace) and no key on the keyboard works
> >> afterwards, until I press Alt. Actually the keys work, but behave as if
> >> the sysrq key was kept pressed (can be seen in dmesg, or by pressing "b").
> >>
> >> Looking at the log, a potential culprit is commit
> >> 97f5f0cd8cd0a05449cbb77d1e6f02e026875802 (Input: implement SysRq as a
> >> separate input handler). Probably the logic of "have to press all the
> >> keys at the same time" changed to "have to press the keys one after each
> >> other". So pressing alt and later on pressing PrintScreen leads to a SysRq.
> >>
> >> Does anybody else see this behaviour? Any suggestion on how to solve
> >> this bug? I'll try reverting the commit and report if it fixes the
> >> problem (the git revert fails so I've got to fix the conflict manually).
> > 
> > Is this still a problem with 2.6.35-rc3?
> The bug is still in 2.6.35-rc3. The patch that fixes this regression is
> in the "for-linus" branch of the input tree, but I think Dmitry hasn't
> yet sent a pull request to Linus.
> 

The fix should be in mainline now.

-- 
Dmitry
