Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2ENFku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:40:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57041 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2ENFkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:40:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120514015536.GA3331@richard>
References: <20120410090306.GA7056@richard>
	<20120422155202.GA13540@richard>
	<4F95B17B.3030401@redhat.com>
	<20120514015536.GA3331@richard>
Date: Sun, 13 May 2012 22:40:41 -0700
X-Google-Sender-Auth: PqyVpdq4dNKfqrzk6MuNn4uW-mQ
Message-ID: <CAE9FiQUjxH+LWy2zbbL6TVQSMZ44i9grFBZf0ZZQFPEWRKANMw@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Yinghai Lu <yinghai@kernel.org>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 6:55 PM, Richard Yang
<weiyang@linux.vnet.ibm.com> wrote:
> On Mon, Apr 23, 2012 at 03:46:03PM -0400, Don Dutile wrote:
>>On 04/22/2012 11:52 AM, Richard Yang wrote:
>>>All,
>>>
>>>I am reading the pci_scan_bridge() and not sure what will happen in
>>>following situation.
>>>
>>>Suppose the kernel is not passed the pci=assign-busses.
>>>
>>>Below is a picture about the pci system.
>>>
>>>                    +-------+
>>>                    |       | root bridge(0,255)
>>>                    +---+---+
>>>                        |          Bus 0
>>>       -----+-----------+------------------------------+--
>>>            |                                          |
>>>            |                                          |
>>>            |                                          |
>>>       +----+----+                               +-----+-----+
>>>       |         |  B1(1,15)                     |           |B2(16,28)
>>>       +----+----+                               +-----+-----+
>>>            |  Bus 1                                   |    Bus 16
>>>       -----+-----------------------         ----------+----------------
>>>                             |
>>>                        +----+----+
>>>                        |         | B3
>>>                        +---------+
>>>
>>>Suppose B1 and B2 works fine with the BIOS, which get the right bus
>>>number and range.
>>>
>>>B3 does not works fine with the BIOS, which doesn't get the bus number.
>>>
>>>So in pci_scan_bridge(), B3 will be met in the second pass and get bus
>>>number 16?
>>
> Yinghai,
>
> Take my original question.
>
> B3 doesn't get the bus number, which its parent doesn't have free bus
> number and there is no gap between B1 and B2.
>
> So in this case, the probe_resource() can't find bus number for B3.
> Then cause pci_bridge_probe_busn_res() return non-zero.
>
> Then B3 couldn't work fine?

B3 is on Bus 1? B3 is the one of bridges on Bus1?

if B3 is only bridge on Bus1, it probe_resource should return [2,15]
at first, and then scan B3.

Yinghai
