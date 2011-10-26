Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab1JZTY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:24:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1JZTY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:24:57 -0400
Date: Wed, 26 Oct 2011 15:24:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: kdump: No udev events for memory hotplug?
Message-ID: <20111026192449.GE355@redhat.com>
References: <1319645292.3321.24.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319645292.3321.24.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 06:08:12PM +0200, Michael Holzheu wrote:
> Hello Vivek and Eric,
> 
> I noticed that on my system kernel 3.1 *no* udev events for memory
> hotplug are generated. Same on my RHEL6.1.
> 
> # udevadm monitor
> # echo offline > /sys/devices/system/memory/memory4/state
> 
> -> No event
> 
> But we need the udev events in order to do a kdump reload for setting up
> the ELF loads correctly.
> 
> In my /etc/udev/rules.d/98-kexec.rules there are rules for memory
> hotplug:
> 
> SUBSYSTEM=="memory", ACTION=="add", PROGRAM="/etc/init.d/kdump restart"
> SUBSYSTEM=="memory", ACTION=="remove", PROGRAM="/etc/init.d/kdump
> restart"
> 
> Perhaps/probably I am missing something?

I don't know. Sounds like a bug. I have never looked into it. CCing Kay,
if he has any thoughts.

Are any events generated for memory add?

Thanks
Vivek
