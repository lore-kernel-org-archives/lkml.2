Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0K3PBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:01:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:58558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0K3PBT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:01:19 -0500
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
In-Reply-To: <20101130145323.GA3291@elte.hu>
References: <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
	 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
	 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
	 <1291052268.32004.171.camel@laptop>
	 <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <1291103647.24405.5.camel@marge.simson.net>
	 <20101130141804.GB22588@elte.hu>  <20101130145323.GA3291@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Nov 2010 16:01:27 +0100
Message-ID: <1291129287.32004.880.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 15:53 +0100, Ingo Molnar wrote:
> another detail is that i needed this fix:
> 
> --- linux.orig/init/Kconfig
> +++ linux/init/Kconfig
> @@ -790,6 +790,7 @@ endif # NAMESPACES
>  
>  config SCHED_AUTOGROUP
>  	bool "Automatic process group scheduling"
> +	select EVENTFD
>  	select CGROUPS
>  	select CGROUP_SCHED
>  	select FAIR_GROUP_SCHED
> 
> Because CGROUPS depends on eventfd infrastructure.

Shouldn't then cgroups select that?
