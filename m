Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1AKMmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:42:44 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62944 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab1AKMml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:42:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OI43Ou8NSM17VkPnFmN9NL4DC+NTtWUE6OUrpQe64Mx68LSKHoL/aa+ywIFDSUyP25
         fxyzwYeYAtO7uiIyrED2mPl3LC62tOQse4UdPOTEk7EESkp9Y0G1y8Ub2KJCYQ9baP5M
         JzSMtdAPj7eZtHNmuRQFsgMYYymPXKLXYqrfI=
MIME-Version: 1.0
In-Reply-To: <20110111112434.GE2385@legolas.emea.dhcp.ti.com>
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
	<1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
	<1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
	<1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
	<20110111112434.GE2385@legolas.emea.dhcp.ti.com>
Date: Tue, 11 Jan 2011 18:12:40 +0530
Message-ID: <AANLkTi=TF9uYEv2Y3qwMKham=K2cCxo4UOTn8Vf+S-KC@mail.gmail.com>
Subject: Re: [RFC V10 3/7] drivers:media:radio: wl128x: FM Driver Common sources
From: Raja Mani <rajambsc@gmail.com>
To: balbi@ti.com
Cc: manjunatha_halli@ti.com, mchehab@infradead.org, hverkuil@xs4all.nl,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

balbi,

  Agree , interrupt pkts could have handled in thread context . But in
the current way , FM driver never create any additional task in the
system
  to handle FM interrupt. In fact, there is no task being created in
this driver to handle FM RDS data, AF,etc.

  This method is suitable for light weight system where we want to
reduce number of thread in the system.

 On Tue, Jan 11, 2011 at 4:54 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Jan 11, 2011 at 06:31:23AM -0500, manjunatha_halli@ti.com wrote:
>> From: Manjunatha Halli <manjunatha_halli@ti.com>
>>
>> These are the sources for the common interfaces required by the
>> FM V4L2 driver for TI WL127x and WL128x chips.
>>
>> These implement the FM channel-8 protocol communication with the
>> chip. This makes use of the Shared Transport as its transport.
>>
>> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
>> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>
> looks like this is implementing a "proprietary" (by that I mean: for
> this driver only) IRQ API. Why aren't you using GENIRQ with threaded
> IRQs support ?
>
> Core IRQ Subsystem would handle a lot of stuff for you.
>
> --
> balbi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards,
Raja.
