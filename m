Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1F1Tra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:47:30 -0400
Received: from claw.goop.org ([74.207.240.146]:59512 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1F1TrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:47:22 -0400
Message-ID: <4E0A2FC7.6020109@goop.org>
Date: Tue, 28 Jun 2011 20:47:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-bluetooth@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc4: regression reconnecting bluetooth headset (A2DP
 fails)
References: <4E03DA75.2080606@goop.org> <20110628182117.GD23183@joana>
In-Reply-To: <20110628182117.GD23183@joana>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 07:21 PM, Gustavo F. Padovan wrote:
> Hi Jeremy,
>
> * Jeremy Fitzhardinge <jeremy@goop.org> [2011-06-23 17:29:41 -0700]:
>
>> I have a Nokia BH-905i headset.  With a stock F15 kernel, it all works
>> well. With current linux-2.6.git, it fails to reconnect properly.
>>
>> On connection, the headphones only beep once, whereas they normally beep
>> twice; I think this is one beep per profile, and its only connecting HSP
>> and failing A2DP.  In the sound control panel, it either comes up with
>> "profile: off" or with the HSP/HFP (Telephony) profile rather than A2DP,
>> and it fails to switch if I try to change profiles via the sound control
>> panel.
>>
>> However, if I re-pair the device from scratch each time I use it, it
>> connects properly and it all works fine.
>>
>> pactl list shows:
>>
>> Card #2
>> 	Name: bluez_card.00_0B_E4_A6_6C_0D
>> 	Driver: module-bluetooth-device.c
>> 	Owner Module: 23
>> 	Properties:
>> 		device.description = "Nokia BH-905i"
>> 		device.string = "00:0B:E4:A6:6C:0D"
>> 		device.api = "bluez"
>> 		device.class = "sound"
>> 		device.bus = "bluetooth"
>> 		device.form_factor = "headset"
>> 		bluez.path = "/org/bluez/843/hci0/dev_00_0B_E4_A6_6C_0D"
>> 		bluez.class = "0x240404"
>> 		bluez.name = "Nokia BH-905i"
>> 		device.icon_name = "audio-headset-bluetooth"
>> 		device.intended_roles = "phone"
>> 	Profiles:
>> 		a2dp: High Fidelity Playback (A2DP) (sinks: 1, sources: 0, priority. 10)
>> 		hsp: Telephony Duplex (HSP/HFP) (sinks: 1, sources: 1, priority. 20)
>> 		off: Off (sinks: 0, sources: 0, priority. 0)
>> 	Active Profile: hsp
>>
>> If I try to switch profiles on the command line it says:
>> $ pactl set-card-profile 2 a2dp
>> Failure: Input/Output error
>>
>> and /var/log/messages shows:
>> module-bluetooth-device.c: A2DP is not connected, refused to switch profile
>>
>> Why isn't A2DP connecting?  How can I debug this further?
> Can you send the output of hcidump with F15 kernel and with linux-2.6.git
> kernel?

This is already fixed in
git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git

Thanks,
    J
