Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0IVS3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:29:30 -0400
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:55897 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754446Ab0IVS33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:29:29 -0400
X-Greylist: delayed 1251 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2010 14:29:28 EDT
Date: Wed, 22 Sep 2010 09:18:00 -0700 (PDT)
From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
cc: anil_ravindranath@pmc-sierra.com
Subject: SMP affinity MSI-X interrupts
Message-ID: <alpine.LNX.1.10.1009220902530.28792@rslab235.pmc-sierra.bc.ca>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 22 Sep 2010 18:08:33.0223 (UTC) FILETIME=[2B32ED70:01CB5A81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Dual Core(and also Quad core) system and a controller which has 
MSI-X interrupts.

What I noticied is that all interrupts coming only on CPU0. The 
system/config is SMP aware.

As we undestand, I try to modify /proc/irq/num/smp_affinity settings to 
get the interrupts for more than one core, what I noticied is if I change 
it to lets say "2", I start getting interrupts only on CPU1. Now I change it 
to "3", but I don't getting interrupts on CPU0 and CPU1. Its not taking 
more than one CPU mask value.

I checked the irq_set_affinity() function and found that it need couple 
of config settings like CONFIG_SMP and CONFIG_GENERIC_PENDING_IRQ and both 
are set in my config.

Looks like, the function irq_affinity_write_proc( ) is also taking "3" 
(more than one CPU mask) correctly.

The irqbalancer is ON . Is there anyother CONFIG setting I am 
missing?

I am using a Distro kernel very latest (2.6.32 based). I can try on a 
latest kernel as well.

with regards,
  Anil
