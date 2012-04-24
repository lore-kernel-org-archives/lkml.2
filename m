Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2DXO4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:56:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51369 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab2DXO4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:56:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXoUcUw5kOcBmsbBu_hJ+GbKk--qFt+WyUHbjJPwY+8Pw@mail.gmail.com>
References: <20120410090306.GA7056@richard>
	<20120422155202.GA13540@richard>
	<CAE9FiQXoUcUw5kOcBmsbBu_hJ+GbKk--qFt+WyUHbjJPwY+8Pw@mail.gmail.com>
Date: Tue, 24 Apr 2012 22:56:19 +0800
Message-ID: <CADLM8XNdfByjCXuEX3pmuUun_qTSZqeARO_vPGy7gc+DoOGxog@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Wei Yang <weiyang.kernel@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/24 Yinghai Lu <yinghai@kernel.org>:
> On Sun, Apr 22, 2012 at 8:52 AM, Richard Yang
> <weiyang@linux.vnet.ibm.com> wrote:
>> All,
>>
>> I am reading the pci_scan_bridge() and not sure what will happen in
>> following situation.
>>
>> Suppose the kernel is not passed the pci=assign-busses.
>>
>> Below is a picture about the pci system.
>>
>>                   +-------+
>>                   |       | root bridge(0,255)
>>                   +---+---+
>>                       |          Bus 0
>>      -----+-----------+------------------------------+--
>>           |                                          |
>>           |                                          |
>>           |                                          |
>>      +----+----+                               +-----+-----+
>>      |         |  B1(1,15)                     |           |B2(16,28)
>>      +----+----+                               +-----+-----+
>>           |  Bus 1                                   |    Bus 16
>>      -----+-----------------------         ----------+----------------
>>                            |
>>                       +----+----+
>>                       |         | B3
>>                       +---------+
>>
>> Suppose B1 and B2 works fine with the BIOS, which get the right bus
>> number and range.
>>
>> B3 does not works fine with the BIOS, which doesn't get the bus number.
>>
>> So in pci_scan_bridge(), B3 will be met in the second pass and get bus
>> number 16?
>> Would this be a conflict?
>
> busn_alloc patchset should address your concern.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-pci-busn-alloc
>
hmm... the code changes too much...
I need more time to understanding it.

while the case i found is different from that reported by Don.

> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Richard Yang
Help You, Help Me
