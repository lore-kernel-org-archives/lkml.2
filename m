Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab1IWDDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 23:03:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54387 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1IWDDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 23:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <CABg=csR-JzS0s2h=B9yJDJBsaAJZTR7b5iH-cU1EjQyxAQjd1g@mail.gmail.com>
References: <CAHzg1A-RCpZz-6YzON4cNzrSVpvEP=BCQx0AzZe1negcu2zo6g@mail.gmail.com>
	<CABg=csR-JzS0s2h=B9yJDJBsaAJZTR7b5iH-cU1EjQyxAQjd1g@mail.gmail.com>
Date: Thu, 22 Sep 2011 20:03:30 -0700
Message-ID: <CAHzg1A950qwmUts4nqKn80izXbxhmzoevg5n3g2C4BbwagmA2g@mail.gmail.com>
Subject: Re: eMMC low write speed
From: Praveen G K <praveen.gk@gmail.com>
To: Qiang LIU <godliuqiang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Qiang,





On Thu, Sep 22, 2011 at 7:16 PM, Qiang LIU <godliuqiang@gmail.com> wrote:
> Hi,
>
> I suggest you change another eMMC card or try SDHC card. It seems like
> a card issue.

Thanks for the response.  So, do you think this has nothing to do with
the caching or any such issues, since it is only every 63rd and 64th
transfer causing this issue?

> What's your environment. Which mode is the host controller, DMA or PIO?

The host controller is in the DMA mode.

> About the bounce buffer, I think is a trade off, if you enlarge its size.
> Sometimes
> will rise timeout error (2s, other polling thread won't gain the host
> controller).
>
> 2011/9/23 Praveen G K <praveen.gk@gmail.com>
>>
>> Hello all,
>>
>> I am working on the block driver module of the eMMC driver.  I am
>> seeing very low write speed for eMMC transfers.  On further debugging,
>> I observed that every 63rd and 64th transfer takes a long time.  I
>> have tabulated this by noting the time interval between when CMD 25
>> (multi block write command) is sent and when DATA_END interrupt is
>> received.  In normal cases, to transfer 64k (128 blocks of data), it
>> takes about 2.5ms.  But, under the really slow transfer speed cases,
>> it takes about 250-350ms to get the data_end interrupt after the multi
>> block write command is sent.  In some cases, it takes a longer time.
>> This radically reduces the throughput of the transfers.
>>
>> I have also enabled the bounce buffers.  As a side question, can
>> somebody please tell me why the bounce buffer is restricted to 64kB?
>>
>> Thanks in advance for any help that you can provide me on this issue.
>> Also, please include my email id in the cc field when replying to this
>> email since I am not subscribed to this mailing list.
>>
>> Thanks,
>> Praveen Krishnan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> Best Regards
> Onizuka Eiji
>
