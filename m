Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0DNQ6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:58:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0DNQ6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:58:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 2/2] microblaze: allow developer selection of STACKTRACE
Date: Wed, 14 Apr 2010 18:57:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: steve@digidescorp.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org
References: <1271220938-3526-1-git-send-email-steve@digidescorp.com> <1271259851.2990.20.camel@iscandar.digidescorp.com> <4BC5F20F.3050108@monstr.eu>
In-Reply-To: <4BC5F20F.3050108@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004141857.34765.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19CnKzVRsyGaVD/LWna46Uue/WO2RAWPsK2TyQ
 n5iB5mMUNHw3NVRh4PXjD6NgtNv8xHU5//j15XWKGHTYlcWhRm
 OKUe/s5E7pChNEu/QAuxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 April 2010, Michal Simek wrote:
> >>> diff -uprN a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> >>> --- a/arch/microblaze/Kconfig       2010-04-09 21:52:36.000000000 -0500
> >>> +++ b/arch/microblaze/Kconfig       2010-04-12 22:16:01.000000000 -0500
> >>> @@ -136,6 +136,14 @@ config PROC_DEVICETREE
> >>>       an image of the device tree that the kernel copies from Open
> >>>       Firmware or other boot firmware. If unsure, say Y here.
> >>>  
> >>> +config PROC_BACKTRACE
> >>> +   bool "Support for kernel backtraces in /proc/NN/stack"
> >>> +   default n
> >>> +   select STACKTRACE
> >>> +   help
> >>> +     This option adds a backtrace of the kernel stack to /proc/NN/stack.
> >>> +     If unsure, say N here.
> >>> +
> >> Why did you create new Kconfig option? /proc/NN/stack is there when you 
> >> enable stacktrace support. There is not necessary to enable any new option.
> >>
> >> Or is there any other point which I am missing?
> > 
> > AFAICT STACKTRACE is an embedded option that isn't presented in the
> > menu. If all you want is /proc/NN/stack without the baggage of kmemleak,
> > tracing, etc., I didn't see a way to configure it.
> 
> Agree that you have to enable some option to get this functionality but 
> the correct question is if someone need only this functionality.
> 
> > 
> > This probably belongs somewhere more generic, maybe lib/Kconfig.debug?
> 
> It is more generic things.
> Arnd: What do you think?

CONFIG_STACKTRACE is currently  silent option that can be selected by
others. If there is value in having it enabled without any of the others,
just make it an explicit option by adding a text to 'config BACKTRACE'
in lib/Kconfig.debug.

	Arnd
