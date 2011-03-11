Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1CKQ1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:27:04 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51592 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1CKQ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:27:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=P0atvCWMKzGGIUnVb/Z2z7RWu/ljzigDVuTZmV7QSWe5RDGEbtkACAyhivx2Q618nA
         1fTkWvMGFzSEVM45BJfRm8MyzI2VlBzEzb733vlEAj7AUHm7iOjcURVup94n71y2Q0Ga
         IqyX8ebggVmlRkup1HNEt8InjTxAnuJl97Xok=
Message-ID: <4D7A4D52.6010501@linaro.org>
Date: Fri, 11 Mar 2011 16:26:58 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Arnd Bergmann <arnd@arndb.de>, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <201103111331.13932.arnd@arndb.de> <20110311152938.GB29920@sirena.org.uk> <201103111654.04089.arnd@arndb.de> <20110311160308.GQ1760@opensource.wolfsonmicro.com>
In-Reply-To: <20110311160308.GQ1760@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 04:03 PM, Somebody in the thread at some point said:
> On Fri, Mar 11, 2011 at 04:54:03PM +0100, Arnd Bergmann wrote:
>> On Friday 11 March 2011, Mark Brown wrote:
>
>>> It's arguable if this stuff is broken at all, from a hardware design
>>> point of view it's perfectly reasonable and if you're shipping volumes
>>> in the millions very small savings add up to interesting numbers easily.
>
>> It may be reasonable if you don't expect anyone to connect the
>> device to an ethernet port, but in that case you could save much
>> more by removing the ethernet chip and the socket along with the
>> eeprom.
>
>> Really, any machine without a fixed MAC address is a huge pain
>> for users, just google for "pandaboard mac address" to see
>> how much work this has caused people.
>
> I'm not familiar with the Pandaboard but most of the devices I've worked
> with that do this have unique MAC addresses but they store in other
> locations on the device (typically in flash).
>
> Like I say, it's not just MAC addresses that can need configuring this
> way - it can be other random "you're wired up this way" type
> information that would normally be figured out from the USB IDs.

Yes that's exactly why I was thinking it's a class of requirement that 
could reasonably be a little API and extending platform_data to it.  So 
anyone with onboard USB device can take advantage if they need to, 
because I guess we see gradually more boards like that.

The driver knows well all about the actual device, but there is a class 
of configuration information that is defined by the physical board 
itself - as you say "how it is wired" - and needs to be passed into the 
driver to inform it of its "functional configuration".  When that 
functional configuration information is a feature of the board alone, 
actually the board definition file is the right place for it.

-Andy
