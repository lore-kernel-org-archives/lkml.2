Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2KFWz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:55:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59957 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2KFWz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:55:58 -0500
Message-ID: <5099957A.4020404@gmail.com>
Date: Tue, 06 Nov 2012 23:55:54 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: S?ren Moch <smoch@web.de>, Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk,
        Gregory Clement <gregory.clement@free-electrons.com>,
        m.szyprowski@samsung.com
Subject: Re: [PATCH V2 1/4] arm: mvebu: increase atomic coherent pool size
 for armada 370/XP
References: <5099810D.9040902@web.de> <20121106223257.GB30428@lunn.ch>
In-Reply-To: <20121106223257.GB30428@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 11:32 PM, Andrew Lunn wrote:
> On Tue, Nov 06, 2012 at 10:28:45PM +0100, S?ren Moch wrote:
>> I see a regression from linux-3.5 to linux-3.6 and think there might
>> be a fundamental problem
>> with this patch. On my Kirkwood system (guruplug server plus) with
>> linux-3.6.2 I see following
>> errors and corresponding malfunction even with further increased
>> (2M, 4M) pool size:
>>
>> Oct 19 00:41:22 guru kernel: ERROR: 4096 KiB atomic DMA coherent
>> pool is too small!
>> Oct 19 00:41:22 guru kernel: Please increase it with coherent_pool=
>> kernel parameter!
>>
>> So I had to downgrade to linux-3.5 which is running without problems.
>>
>> I use SATA and several DVB sticks (em28xx / drxk and dib0700).
>
> I'm guess its the DVB sticks which are causing the problems. We have a
> number of kirkwood devices with two SATA devices which had problems
> until we extended the coherent_pool. The DVB sticks are probably take
> more coherent RAM. There was also an issue found recently:
>
> http://www.spinics.net/lists/arm-kernel/msg203962.html
>
> That conversation has gone quiet, but that could be because the
> participants are at ELCE.

So what is the call here? Should we just increase the coherent buffer
size back to what it was before? I am not into this too much but just
increasing the buffer will just postpone the actual issue to a later
point in running the kernel?

Sebastian
