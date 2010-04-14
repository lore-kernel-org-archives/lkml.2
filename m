Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab0DNPoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:44:19 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:42616 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab0DNPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:44:18 -0400
X-Spam-Processed: digidescorp.com, Wed, 14 Apr 2010 10:44:16 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1720206d9c=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] microblaze: allow developer selection of STACKTRACE
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
In-Reply-To: <4BC5DE54.2010305@monstr.eu>
References: <1271220938-3526-1-git-send-email-steve@digidescorp.com>
	 <4BC5DE54.2010305@monstr.eu>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Wed, 14 Apr 2010 10:44:11 -0500
Message-Id: <1271259851.2990.20.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-14 at 17:25 +0200, Michal Simek wrote:
> Steven J. Magnani wrote:
> > Allow the developer to configure STACKTRACE to enable userland access to backtraces in /proc/NN/stack.
> > 
> > Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> > ---
> > diff -uprN a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> > --- a/arch/microblaze/Kconfig	2010-04-09 21:52:36.000000000 -0500
> > +++ b/arch/microblaze/Kconfig	2010-04-12 22:16:01.000000000 -0500
> > @@ -136,6 +136,14 @@ config PROC_DEVICETREE
> >  	  an image of the device tree that the kernel copies from Open
> >  	  Firmware or other boot firmware. If unsure, say Y here.
> >  
> > +config PROC_BACKTRACE
> > +	bool "Support for kernel backtraces in /proc/NN/stack"
> > +	default n
> > +	select STACKTRACE
> > +	help
> > +	  This option adds a backtrace of the kernel stack to /proc/NN/stack.
> > +	  If unsure, say N here.
> > +
> 
> Why did you create new Kconfig option? /proc/NN/stack is there when you 
> enable stacktrace support. There is not necessary to enable any new option.
> 
> Or is there any other point which I am missing?

AFAICT STACKTRACE is an embedded option that isn't presented in the
menu. If all you want is /proc/NN/stack without the baggage of kmemleak,
tracing, etc., I didn't see a way to configure it.

This probably belongs somewhere more generic, maybe lib/Kconfig.debug?

Steve


