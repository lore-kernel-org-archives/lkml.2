Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab0HCKXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:23:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:47464 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab0HCKXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:23:24 -0400
Message-ID: <4C57EC58.4020301@suse.de>
Date: Tue, 03 Aug 2010 12:15:52 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de> <4C56E5C7.90206@suse.de> <alpine.LFD.2.00.1008022022560.27107@localhost.localdomain> <4C572327.7040801@suse.de> <alpine.LFD.2.00.1008031205040.3225@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1008031205040.3225@localhost.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/03/2010 12:06 PM, Thomas Gleixner wrote:
>> These problems do happen on intel chipset machines and is something
>> which can be worked around with some effort.  Eh, let's talk on the
>> other reply.
> 
> So you're saying that the ATA problem is restricted to Intel chipsets?
> Do we know the root cause ?

The original sentence is missing an 'also'.  Severals have been root
caused and worked around.  For SATA, one of the notable problems was
misinterpretation of nIEN (interrupt block bit on the ATA device side)
on both device and host sides.  In traditional IDE API, the interrupt
bit is primarily under the control of the device, so it's pretty
difficult to guarantee reliable operation from driver side only.  For
PATA, the device actually has full control of the interrupt line, so
it's much worse.

Thanks.

-- 
tejun
