Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1J0HbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:31:06 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:56607 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1J0HbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:31:03 -0400
Date: Thu, 27 Oct 2011 09:30:58 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: kdump: No udev events for memory hotplug?
Message-ID: <20111027073058.GA2422@osiris.boeblingen.de.ibm.com>
References: <1319645292.3321.24.camel@br98xy6r>
 <20111026192449.GE355@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026192449.GE355@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 03:24:49PM -0400, Vivek Goyal wrote:
> On Wed, Oct 26, 2011 at 06:08:12PM +0200, Michael Holzheu wrote:
> > Hello Vivek and Eric,
> > 
> > I noticed that on my system kernel 3.1 *no* udev events for memory
> > hotplug are generated. Same on my RHEL6.1.
> > 
> > # udevadm monitor
> > # echo offline > /sys/devices/system/memory/memory4/state
> > 
> > -> No event
> > 
> > But we need the udev events in order to do a kdump reload for setting up
> > the ELF loads correctly.
> > 
> > In my /etc/udev/rules.d/98-kexec.rules there are rules for memory
> > hotplug:
> > 
> > SUBSYSTEM=="memory", ACTION=="add", PROGRAM="/etc/init.d/kdump restart"
> > SUBSYSTEM=="memory", ACTION=="remove", PROGRAM="/etc/init.d/kdump
> > restart"
> > 
> > Perhaps/probably I am missing something?
> 
> I don't know. Sounds like a bug. I have never looked into it. CCing Kay,
> if he has any thoughts.
> 
> Are any events generated for memory add?

Looks like uevents are only genereted when memory gets registered and
unregistered, but not when when it gets set online or offline.
To achieve that you would need to add similar code to
store_mem_state()/memory_block_change_state() in drivers/base/memory.c
like we have it already in store_online() in drivers/base/cpu.c
