Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab2CQO7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 10:59:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9562 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2CQO7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 10:59:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6651"; a="173382376"
Message-ID: <7617aa6aec2aee6031353d55fec0d53a.squirrel@www.codeaurora.org>
In-Reply-To: <000301cd00b2$d08a84d0$719f8e70$%jun@samsung.com>
References: <4934441a17d25c3249556f7bf281b1be.squirrel@www.codeaurora.org>
    <CAKYAXd_6OqQJ78mPJp11gRvGwwg88S_n_Auu=_HdP_ZXzCKrDg@mail.gmail.com>
    <6669559e86c1d13b27e941ff2acf89d2.squirrel@www.codeaurora.org>
    <CAKYAXd8HMrdB9mzgsz5XmMxkDE+gMce+CTEDFU4J67nusNtLOg@mail.gmail.com>
    <cf2950fbeb4c500534be670cdd8cf85d.squirrel@www.codeaurora.org>
    <000001ccfbf7$ac3e7510$04bb5f30$%jun@samsung.com>
    <dbfd894b689405f525e17aa5373a2602.squirrel@www.codeaurora.org>
    <000301cd00b2$d08a84d0$719f8e70$%jun@samsung.com>
Date: Sat, 17 Mar 2012 07:59:44 -0700 (PDT)
Subject: RE: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: merez@codeaurora.org, "'Namjae Jeon'" <linkinjeon@gmail.com>,
        linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maya Erez <merez@codeaurora.org> wrote:
>> > Maya Erez <merez@codeaurora.org> wrote:
>> >> > Hi. Merez.
>> >> >
>> >> > Thanks a lot about your performance measurement.
>> >> >
>> >> > I think that your measurement is enough and correct and the
>> firmware
>> >> > of mmc vender should be optimized or change properly rather than
>> >> > modifying the current patch.
>> >> >
>> >> > And currently we can use only write packed cmd by my suggestion.
>> >> >
>> >> > I would like to add my reviewd-by tag in updated patches also.
>> >> >
>> >> > Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
>> >> >
>> >> > Thanks.
>> >>
>> >> I tend to disagree. Adding a massive amount of code that would be
>> >> disabled
>> >> can be risky. In case this code will not be in use it will not be
>> >> properly
>> >> tested and its reliability will be uncertain.
>> >>
>> > If you found something to be correct, please let me know that.
>> > It would be rightly appreciated.
>> >
>> > Best regards,
>> > Seungwon Jeon.
>> Hi Jeon,
>>
>> The write packing code looks good to me.
>> However, the separation of read and write packing to different patches
>> is
>> very important to us.
>> As I specified before, we decided to enable only the write packing. We
>> plan to thoroughly test the write packing (edge cases and error
>> handling)
>> and will not test the read packing. Therefore we would like to have the
>> ability to get only the write packing code.
> As Namjae Jeon mentioned, how about this?
> I think only MMC_CAP2_PACKED_WR can be set for enabling the write packing
> easily.
> In my case, tested eMMC device is not optimized for packed read.
> So I couldn't confirm that this patch is effective in packed read.
This supports my suggestion to separate the write and read packing. Let's
wait for the read packing to be proven as effective before mainlining it.
Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

> I think packed read as well as packed write of this patch conformed with
> the eMMC4.5 spec though.
> I wonder that your eMMC device has the good ability in both operations.
> It is difficult to decide the performance with excluding the device.
> Soon I will test it with the improved sample for packed read.
>
>> In my previous comment I talked about the risk of mainlining  a “dead”
>> code. Every feature that is integrated is considered to be fully tested
>> and in the future it might be enabled, assuming that is was already
>> tested.
> Right! It is desirable and I hope that.
> Do you think this patch have the potential problem?
> As I also ask you, if you have tested and find something is incorrect, we
> can discuss that.
> It was submitted for that purpose.
>
>> Can you please specify how you tested the read and write packing? Did
>> you
>> perform edge cases and error handling tests? Do you have test code that
>> can be shared?
> Basically, It has been tested with several I/O benchmark tool.
> Some misvalued I/O timing and wrong argument for packed command
> was used for triggering the error case.
>
> Best regards,
> Seungwon Jeon.
>>
>> Thanks,
>> Maya Erez
>> Consultant for Qualcomm Innovation Center, Inc.
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


