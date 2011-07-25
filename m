Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1GYOgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:36:53 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62829 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1GYOgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:36:51 -0400
MIME-Version: 1.0
In-Reply-To: <1311593444.29703.20.camel@vkoul-mobl4>
References: <1311453088-5063-1-git-send-email-jaswinder.singh@linaro.org>
	<1311593444.29703.20.camel@vkoul-mobl4>
Date: Mon, 25 Jul 2011 20:06:50 +0530
Message-ID: <CAJe_Zhc8HjHoF=wjhw76x=UmjE879RWNZigq9TwhjecsiSu9sg@mail.gmail.com>
Subject: Re: [RFC] DMAEngine: Define generic transfer request api
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: Vinod Koul <vkoul@infradead.org>
Cc: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        sundaram@ti.com, linus.walleij@linaro.org, rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2011 17:00, Vinod Koul <vkoul@infradead.org> wrote:
> On Sun, 2011-07-24 at 02:01 +0530, Jassi Brar wrote:
>> This is an attempt to define an api that could be used for doing
>> fancy data transfers like interleaved to contiguous copy and vice-versa.
>> Traditional SG_list based transfers tend to be very inefficient
>> in such cases. Such cases call for some very condensed api to convey
>> pattern of the transfer. This is an attempt at that condensed api.
>>
>> The api supports all 4 variants of scatter-gather and contiguous transfer.
>> Besides, it could easily represent common operations like
>>       device_prep_dma_{cyclic, memset, memcpy}
> and how do you specify if the transfer is cyclic, memset or mempcy...
Sorry I missed this in the dense. Maybe it's a good idea to isolate
enough the context and reply in a post ?

Cyclic - I have already explained to Linus. Please ask for clarifications.

Memset (with pattern of source bus-width size)
*********
struct xfer_template {
       bool src_inc = false;
       bool dst_inc = true;
       size_t numf = memset_length / pattern_size;
       size_t frame_size = 1;
       struct data_chunk sgl[0]   represents the pattern to be repeated
};

If we need to set memory with a pattern or arbitrary length, we can
add read-width and write-width members(actually I just removed before
posting).
