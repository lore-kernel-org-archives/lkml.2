Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab0FUGgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 02:36:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39507 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0FUGf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 02:35:58 -0400
Date: Mon, 21 Jun 2010 08:35:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #16054] UML broken for CONFIG_SLAB
Message-ID: <20100621063552.GA16491@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Parag Warudkar <parag.lkml@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
 <rHrHQMIU4rI.A.h6.rapHMB@chimera>
 <AANLkTiks4DUvSLQLHb1Tr6cO_Mma-9UcDRqJ5uafdt1R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTiks4DUvSLQLHb1Tr6cO_Mma-9UcDRqJ5uafdt1R@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Parag Warudkar <parag.lkml@gmail.com>
Date: Sun, Jun 20, 2010 at 06:48:55PM -0400

> Still broken. Borislav's fix on top of git a few days ago doesn't seem to
> cure it.

Everyone else has reported that
http://git.kernel.org/tip/055c47272b8f5679d08ccc57efea3cb4aaeb5fc6 fixes
the boot issue for them.

One problem with testing this patch was making sure you do a completely
clean build by removing the old build files through a 'make mrproper.'
So, after applying this patch do (after having copied your .config to a
safe place :))

make mrproper

and just to make sure no arch_hweight stuff is left, do

grep -EriIn 'x86.*hweight\.h' arch/um/

You shouldn't be getting any matches. If you do, than try to find out
why you do because all those intermediary *.o.cmd files shouldn't
contain any hweight-include files from arch/x86/.

> On Jun 20, 2010 6:45 PM, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16054
> Subject         : UML broken for CONFIG_SLAB
> Submitter       : Parag Warudkar <parag.lkml@gmail.com>
> Date            : 2010-05-23 21:40 (29 days old)
> Message-ID      : <alpine.DEB.2.00.1005231149100.605@parag-laptop>
> References      : http://marc.info/?l=linux-kernel&m=127465083806617&w=2
> Handled-By      : Borislav Petkov <bp@alien8.de>
> Patch           :
> http://git.kernel.org/tip/055c47272b8f5679d08ccc57efea3cb4aaeb5fc6

-- 
Regards/Gruss,
    Boris.
