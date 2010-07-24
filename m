Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0GXMCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 08:02:41 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:35409 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754619Ab0GXMCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 08:02:40 -0400
Message-ID: <4C4AD65D.5090008@ribosome.natur.cuni.cz>
Date: Sat, 24 Jul 2010 14:02:37 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100516 Gentoo/2.0.4-r1 SeaMonkey/2.0.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Jay Fenlason <fenlason@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.35-rc6 to 2.6.32.16: JuJu firewire issues
References: <4C49A291.20001@ribosome.natur.cuni.cz> <20100723180807.GA32319@redhat.com> <4C49E1A2.7050606@ribosome.natur.cuni.cz> <4C4A074D.4050305@s5r6.in-berlin.de> <4C4A9DD8.9080200@s5r6.in-berlin.de>
In-Reply-To: <4C4A9DD8.9080200@s5r6.in-berlin.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,
  thank you for your care of this issue. I have just returned the crappy
IcyBOX IB-250StUE-B back to the reseller. On the circuit board there was
Apr 2008 timestamp (regarding the JMicron JMB 353 chip doing the SATA to
FireWire 1394a + USB 2.0 conversion).

  I tried in the morning to connect the IcyBox to this laptops internal
Ricoh Co Ltd R5C552 IEEE 1394 Controller but had issues to power-up the drive
at all. Not even using USB hub to supply power to it. I connected it to
the ricoh chip via a 6 to 4 pin cable but also tried the not very good
Kouwell 7004 PCMCIA card (which does not supply enough power unless I
buy external, optional power supply of unknown specs and plug it into the
PCMCIA card).

Many thanks for your care,
Martin
P.S.: Yes, laptop (computer B) is a single-core, old P4-M computer with ICH3
chipset. 

Stefan Richter wrote:
> Stefan Richter wrote:
>> Martin Mokrejs wrote at LKML:
>>> Hi Jay,
>>> Jay Fenlason wrote:
>>>> On Fri, Jul 23, 2010 at 04:09:21PM +0200, Martin Mokrejs wrote:
>>>>> Hi,
>>>>>   I bought a external harddrive with firewire and USB interfaces (IcyBOX IB-250StUE-B).
>>>>> If I connect it to a desktop computer A I get kernel crash during boot (see
>>>>> both attached dmesg-*.txt files).
>>
>> The crash which you reported is in sbp2 (of the old ieee1394 stack alias
>> linux1394, not in firewire-sbp2 (of the new firewire stack alias juju).
> 
> I have logged your report as
> 	https://bugzilla.kernel.org/show_bug.cgi?id=16452
> 	nodemgr, sbp2: NULL pointer dereference in sbp2_update
> but set its status to WILL_NOT_FIX for now.
> 
> The bug seems to be in the nodemgr component of the ieee1394 core
> driver.  This is one of the things that were rewritten from scratch in
> firewire-core with a fundamentally different implementation, for good
> reasons.
> 
> Perhaps somebody else wants to look into a possible fix for this bug,
> but this seems very unlikely.  (Basically, a bug fix already exists in
> the form of firewire-core.)
