Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1KGRIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:08:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60789 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1KGRIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:08:04 -0500
MIME-Version: 1.0
In-Reply-To: <CANudz+soE9ax7668gh2TRxfnvPoAapKunwsXCc-T3ff0GAL6zg@mail.gmail.com>
References: <CANudz+unARaENw50p2iL_Ur1YQj0f=9Ndev0OyZ=790xDjbTCw@mail.gmail.com>
	<20111101082653.4fa844e4@bike.lwn.net>
	<CANudz+soE9ax7668gh2TRxfnvPoAapKunwsXCc-T3ff0GAL6zg@mail.gmail.com>
Date: Mon, 7 Nov 2011 09:08:03 -0800
Message-ID: <CABi1daFSV6ByHQ59zwbPjEeg5Mood9XUw=N4LeSD+bFGU4+_4Q@mail.gmail.com>
Subject: Re: some questions about block and scatterlist
From: Dave Hylands <dhylands@gmail.com>
To: loody <miloody@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi loody,

On Mon, Nov 7, 2011 at 5:16 AM, loody <miloody@gmail.com> wrote:
...snip...
>>> 1. Are all struct page 32-bit aligned?
>>
>> Certainly, I would expect any structures found in the system memory map to
>> be so aligned, yes.  If you've created an arbitrary one elsewhere I'm only
>> 99% sure it would be.
>>
>>> If so, where is this part of code for handleing struct page be 32-bits aligned?
>>
>> Note that the size of struct page is carefully considered, and that they
>> are packed as densely as possible, both externally and internally.  No
>> lesser alignment would make sense.
> I found kernel stealing LSB of page_link to put additional
> information, such as sg_is_chain and sg_is_last.
>
> That means the address of all pages have to be at least 4byte alignment.
> But I didn't see any additional attribute added at the end of struct
> or any precaution to take care this.

This is done automatically by the compiler.
http://en.wikipedia.org/wiki/Data_structure_alignment

-- 
Dave Hylands
Shuswap, BC, Canada
http://www.davehylands.com
