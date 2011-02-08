Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1BHHzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 02:55:21 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:48640 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1BHHzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 02:55:20 -0500
X-Auth-Info: abF9G/0zPcQWUKNHpxcVsSmyMa8tM5kNv+o0ZpyAcfI=
Message-ID: <4D50F75A.5040700@grandegger.com>
Date: Tue, 08 Feb 2011 08:57:14 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: About bittiming calculation result
References: <cover.1296818921.git.segoon@openwall.com><a6800dc8b0daed78256f98f52844cbbb48f4a76d.1296818921.git.segoon@openwall.com><20110204124233.GB334@e-circ.dyndns.org>	<20110204.130649.112613896.davem@davemloft.net>	<5009516791F146C49C73FAC57C437313@hacdom.okisemi.com>	<4D4FDEF9.2030305@grandegger.com> <4D501555.5000905@grandegger.com> <93C12206407640199DCDD3A89A333F13@hacdom.okisemi.com>
In-Reply-To: <93C12206407640199DCDD3A89A333F13@hacdom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On 02/08/2011 02:27 AM, Tomoya MORINAGA wrote:
> On Tuesday, February 08, 2011 12:53 AM,  Wolfgang Grandegger wrote:
> 
>> BTW, it's always possible to specify optimized bit-timing 
>> parameters directly, e.g. the following seem better:
>>
>>    800000     60  12    4    4   4   3  793650  0.8% 80.0% 81.0%  1.2%
>>
>> You could set these with:
>>
>>   $ ip link set can0 type can \
>>     tq 60 prop-seg 12 phase-seg1 4 phase-seg2 4 sjw 4
> 
> I can confirm 800K comms works well using the above.

Cool, I got these magic values from a CAN hardware expert.

> I wish Can-core could calculate like above.

Me too! I also got some indication on how to improve our algorithm in
case the bit-rate does not match. Hope to find some time soon to work
on this issue.

>>> seg1/seg2/sjw/prop_seg must be more than 1 ?
> BTW, according to EG20T PCH data sheet, 
> CAN bit-timing parameters(BRP, Prop_Seg, Phase_Seg1, Phase_Seg2, SJW) must not be set 0.

OK, then please provide a patch setting tseg1_min to 2.

Wolfgang.
