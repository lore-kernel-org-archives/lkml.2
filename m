Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab0CVTZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:25:22 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:50616 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0CVTZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:25:19 -0400
X-Auth-Info: 9aZ+3OUYeTnwoRcq5IA/ua+W/e2Ri9NdALrFkHZTfXs=
Message-ID: <4BA7C3BE.8040306@grandegger.com>
Date: Mon, 22 Mar 2010 20:23:42 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN	module
References: <>	<1268930324-29841-3-git-send-email-iws@ovro.caltech.edu>	<4BA33D5A.8070000@grandegger.com>	<20100319151914.GB13672@ovro.caltech.edu>	<4BA39C05.8050800@grandegger.com>	<20100319200325.GE13672@ovro.caltech.edu>	<4BA3DAF1.4090206@grandegger.com>	<20100319215227.GF13672@ovro.caltech.edu>	<4BA47F64.8030108@grandegger.com>	<20100322155318.GA19251@ovro.caltech.edu> <4BA7C236.9060609@grandegger.com>
In-Reply-To: <4BA7C236.9060609@grandegger.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Grandegger wrote:
> Ira W. Snyder wrote:
>> On Sat, Mar 20, 2010 at 08:55:16AM +0100, Wolfgang Grandegger wrote:
>>> Ira W. Snyder wrote:
> [snip]
>>>> Does this seem right? It seems pretty good to me.
>>> Yes, I'm just missing an error-passive message. What state does "ip -d
>>> link show can0" report.
>>>
>> Ok, here is what I did:
>>
>> $ ip link set can0 up type can bitrate 1000000
>> $ ip link set can1 up type can bitrate 1000000 berr-reporting on
>> $ ip -d -s link
>> 5: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN qlen 10
>>     link/can       
>>     can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
>>     bitrate 1000000 sample-point 0.750
>>     tq 125 prop-seg 2 phase-seg1 3 phase-seg2 2 sjw 1
>>     janz-ican3: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..64 brp-inc 1
>>     clock 8000000  
>>     re-started bus-errors arbit-lost error-warn error-pass bus-off
>>     0          0          0          0          0          0
>>     RX: bytes  packets  errors  dropped overrun mcast
>>     0          0        0       0       0       0
>>     TX: bytes  packets  errors  dropped carrier collsns
>>     0          0        0       0       0       0
>> 6: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN qlen 10
>>     link/can       
>>     can <BERR-REPORTING> state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
>>     bitrate 1000000 sample-point 0.750
>>     tq 125 prop-seg 2 phase-seg1 3 phase-seg2 2 sjw 1
>>     janz-ican3: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..64 brp-inc 1
>>     clock 8000000  
>>     re-started bus-errors arbit-lost error-warn error-pass bus-off
>>     0          0          0          0          0          0
>>     RX: bytes  packets  errors  dropped overrun mcast
>>     0          0        0       0       0       0
>>     TX: bytes  packets  errors  dropped carrier collsns
>>     0          0        0       0       0       0
>>
>> Now, in seperate windows, I ran cansequence and candump. I stopped
>> cansequence when it could not send any more packets (due to the cable
>> being unplugged).
>>
>> $ cansequence -v -e -p can0
>> $ cansequence -v -e -p can1
>> $ candump any,0~0,#FFFFFFFF
>>   can0  20000004  [8] 00 08 00 00 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000004  [8] 00 08 00 00 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>   can1  20000088  [8] 00 00 80 19 00 00 00 00   ERRORFRAME
>>
>> This last message is repeated lots more times. That's the flooding we're
>> avoiding with berr-reporting off.
>>
>> I see two types of messages here:
>> 1) bus error (only on can1)
>> 2) controller problems -- tx warning limit reached (both)
>>
>> Am I missing some message? My error frame generation was mostly copied
>> from the sja1000 driver.
> 
> It seem that you are not getting the error passive interrupt even...

Because you do not enable/handle it. CEVTIND_EPI seems to be missing:

http://lxr.linux.no/#linux+v2.6.33/drivers/net/can/sja1000/sja1000.c#L403

Wolfgang.
