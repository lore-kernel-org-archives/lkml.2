Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161516Ab2GLSNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 14:13:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40830 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2GLSNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 14:13:07 -0400
MIME-Version: 1.0
In-Reply-To: <1342016239.3265.8007.camel@edumazet-glaptop>
References: <CAP2AAQMvx5yxVRLN4AT_YdsFJAUDRgSNwzq0A3x8JyZgXKEjmw@mail.gmail.com>
	<1342016239.3265.8007.camel@edumazet-glaptop>
Date: Thu, 12 Jul 2012 15:05:59 -0300
Message-ID: <CAP2AAQM-M87NatYG1+u4Z+OC49wVe6CHYNCu+O3HAvAZYGZOQA@mail.gmail.com>
Subject: Re: Protocol handler using dev_add_pack
From: Jerry Yu <jerryy@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

Thank you very much. Once I disabled scatter-gather on the NIC, the
issue disappeared. Now I just need to figure out how to access the
paged data if the scatter-gather I/O feature enabled. Seems that the
functions to map and unmap frag pages ( kmap_skb_frag and
kunmap_skb_frag) are removed from skbuff.h in 3.2.0-26. I may have to
create similar functions by myself.

Thanks again,

Jerry

On Wed, Jul 11, 2012 at 11:17 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2012-07-11 at 10:38 -0300, Jerry Yu wrote:
>> I am working on a kernel module to monitor all TCP packets. I created a protocol
>> handler with protocol code ETH_P_ALL to handle all incoming and outgoing
>> TCP packets. The code worked fine on 2.6.14 kernel, but in current 3.2.0-26
>> kernel, I am no longer able to get the TCP payload for outgoing packets.
>> The data in TCP payload section of skb->data are mainly 0x00. I am still
>> able to get incoming TCP packets' payloads though.
>>
>> Is there any change in 3.2.0 or other early kernel versions that will cause
>> this issue?
>
> Maybe you make wrong assumptions in your code.
>
> skb->data doesnt exactly contains tcp payload of locally generated TCP
> packets, unless you disabled scatter-gather on the NIC
>
> ehtool -K eth0 sg off
>
>
>
