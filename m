Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0JNHrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:47:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56102 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab0JNHrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:47:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CB6B570.6030509@s5r6.in-berlin.de>
Date: Thu, 14 Oct 2010 09:46:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ieee1394: remove the old IEEE 1394 driver stack
References: <tkrat.a80c49c9cfb3380e@s5r6.in-berlin.de>	 <tkrat.3d7c94e2ecb3a995@s5r6.in-berlin.de> <1287014362.23588.1.camel@maxim-laptop>
In-Reply-To: <1287014362.23588.1.camel@maxim-laptop>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> On Sun, 2010-10-10 at 00:12 +0200, Stefan Richter wrote:
>> The drivers
>>   - ohci1394 (controller driver)
>>   - ieee1394 (core)
>>   - dv1394, raw1394, video1394 (userspace ABI)
>>   - eth1394, sbp2 (protocol drivers)
>> are replaced by
>>   - firewire-ohci (controller driver)
>>   - firewire-core (core and userspace ABI)
>>   - firewire-net, firewire-sbp2 (protocol drivers)
>> which are more featureful, better performing, and more secure than the older
>> drivers; all with a smaller and more modern code base.
> But new stack doesn't have working networking support...

firewire-net did work for me to /some/ degree when I tested it last:  Transfer
s via FTP or SCP command line clients was OK, even with huge files, but an
attempt to use FTP via desktop file manager ended in kernel crash.

In contrast, eth1394 worked to /some/ other degree for me when I tested it
last:  It never crashed, but it had irregular performance (due to DMA context
program overflow, besides ieee1394's tlabel recycling in a wrong context) when
paired with {Linux,Windows,OS X}/x86, whereas transfers from and to an OS
X/PPC peer always failed due to data corruption.

That's what I meant with
>>   - The experimental firewire-net is reportedly less stable than its
>>     experimental cousin eth1394.

Maybe these words were too kind to firewire-net.

eth1394 was never stabilized because there was nobody there to do so.  Will
somebody be there to stabilize firewire-net?  A while ago I spent the time to
fix an SMP bug in firewire-net.  Lately I looked a bit into the currently
known crash bug but obviously did not resolve it yet.  At the moment I suspect
a race between fw_card_driver.send_request and fw_card_driver.cancel_packet
but did not find a hole in that code yet.

Overall I am not convinced that this or any of the other open issues that I
mentioned warrants to stretch out the coexistence of two 1394 kernel stacks
further.  Many distributors still enable only the old, buggy, virtually
unmaintained stack.  Some distributors enable both stacks but are not aware
that they then should also provide a modprobe blacklist file, and their users
end up running a random set of drivers.  Until 2.6.36-rc4 inclusive that
usually seemed to be the old stack; from 2.6.36-rc5 onwards that randomness
will probably be skewed towards the new stack.  There is only one way to fix
that only seemingly trivial deployment issue.
-- 
Stefan Richter
-=====-==-=- =-=- -===-
http://arcgraph.de/sr/
