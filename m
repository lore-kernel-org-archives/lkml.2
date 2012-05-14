Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2ENGqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 02:46:24 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:48757 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab2ENGqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 02:46:23 -0400
Date: Mon, 14 May 2012 14:46:15 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
Message-ID: <20120514064615.GB26605@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
References: <20120410090306.GA7056@richard>
 <20120422155202.GA13540@richard>
 <4F95B17B.3030401@redhat.com>
 <20120514015536.GA3331@richard>
 <CAE9FiQUjxH+LWy2zbbL6TVQSMZ44i9grFBZf0ZZQFPEWRKANMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUjxH+LWy2zbbL6TVQSMZ44i9grFBZf0ZZQFPEWRKANMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12051406-8878-0000-0000-000002713600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 10:40:41PM -0700, Yinghai Lu wrote:
>On Sun, May 13, 2012 at 6:55 PM, Richard Yang
><weiyang@linux.vnet.ibm.com> wrote:
>> On Mon, Apr 23, 2012 at 03:46:03PM -0400, Don Dutile wrote:
>>>On 04/22/2012 11:52 AM, Richard Yang wrote:
>>>>All,
>>>>
>>>>I am reading the pci_scan_bridge() and not sure what will happen in
>>>>following situation.
>>>>
>>>>Suppose the kernel is not passed the pci=assign-busses.
>>>>
>>>>Below is a picture about the pci system.
>>>>
>>>>                    +-------+
>>>>                    |       | root bridge(0,255)
>>>>                    +---+---+
>>>>                        |          Bus 0
>>>>       -----+-----------+------------------------------+--
>>>>            |                                          |
>>>>            |                                          |
>>>>            |                                          |
>>>>       +----+----+                               +-----+-----+
>>>>       |         |  B1(1,15)                     |           |B2(16,28)
>>>>       +----+----+                               +-----+-----+
>>>>            |  Bus 1                                   |    Bus 16
>>>>       -----+-----------------------         ----------+----------------
>>>>                             |
>>>>                        +----+----+
>>>>                        |         | B3
>>>>                        +---------+
>>>>
>>>>Suppose B1 and B2 works fine with the BIOS, which get the right bus
>>>>number and range.
>>>>
>>>>B3 does not works fine with the BIOS, which doesn't get the bus number.
>>>>
>>>>So in pci_scan_bridge(), B3 will be met in the second pass and get bus
>>>>number 16?
>>>
>> Yinghai,
>>
>> Take my original question.
>>
>> B3 doesn't get the bus number, which its parent doesn't have free bus
>> number and there is no gap between B1 and B2.
>>
>> So in this case, the probe_resource() can't find bus number for B3.
>> Then cause pci_bridge_probe_busn_res() return non-zero.
>>
>> Then B3 couldn't work fine?
>
>B3 is on Bus 1? B3 is the one of bridges on Bus1?
No,  I omit other bridges on Bus#1.
They will occupy bus number 2-15, which is calculated by BIOS and set to
bridge's configuration space.
>
>if B3 is only bridge on Bus1, it probe_resource should return [2,15]
>at first, and then scan B3.
>
>Yinghai

-- 
Richard Yang
Help you, Help me

