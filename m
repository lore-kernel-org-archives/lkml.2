Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1IUBOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 21:14:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62849 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1IUBOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 21:14:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd8uU+JEqJQZ6a7oBoynpLQ2=+gOk-Ue47y+HZgBsatGRQ@mail.gmail.com>
References: <1316359301-2263-1-git-send-email-linkinjeon@gmail.com>
	<4E78433F.2050900@stericsson.com>
	<CA+Wuu-vAx8PkvPgy5mR5Bcg6e+q6Z3XOZtTGwNZgCW4HCrX5KA@mail.gmail.com>
	<CAKYAXd9bmw12By6StTL_MRzAGsgG9BOfcvs=TA-nRu_uxMzOcw@mail.gmail.com>
	<CA+Wuu-sK6B_k0+sG_p4JRuHOwO_HVCpNksg-9_TdpzXRS7y0xA@mail.gmail.com>
	<CAKYAXd8WiakFVy_ykpbw-Eq+XDgX0NECtJZFDy3WzxtNfJmdkw@mail.gmail.com>
	<CA+Wuu-vG7QMcRwvi8F4rznQda3OmyEueNGDv=8gXkB6YVBWEaA@mail.gmail.com>
	<CAKYAXd8uU+JEqJQZ6a7oBoynpLQ2=+gOk-Ue47y+HZgBsatGRQ@mail.gmail.com>
Date: Wed, 21 Sep 2011 10:14:46 +0900
Message-ID: <CAKYAXd9ae_b_gq4GwXVjM4XDQAypOpKMEGz2_SN0uyV03OAPkA@mail.gmail.com>
Subject: Re: [PATCH] mmc : Use wait_for_completion_timeout() instead of
 wait_for_completion in case of write.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Murali Krishna Palnati <palnati.muralikrishna@gmail.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/21 NamJae Jeon <linkinjeon@gmail.com>:
> 2011/9/21 Murali Krishna Palnati <palnati.muralikrishna@gmail.com>:
>> On Tue, Sep 20, 2011 at 7:52 PM, NamJae Jeon <linkinjeon@gmail.com> wrote:
>>> It may be no good choice that sw timer is on host driver. also I don't
>>> know what is different.
>>
>> It helps to have this functionality implemented at host controller
>> layer so that the host layer is informed about this. If we just end
>> the request from the MMC core layer, host controller driver doesnt
>> even kow about that and it remains in the same state processing the
>> request (that already got timed out at core layer). It is good to have
>> the host layer trigger this timeout, do necessary clean up and then
>> duly end the request by informing the core layer by calling
>> mmc_request_done().
>>
>> Let me put the question in this way. If the core layer times out
>> (because of wait_for_completion_timeout) then in the patch that you
>> have submitted, i dont see how the host layer knows about it.
>> Apologize, if i sound like a broken record saying the same thing again
>> and again.
>>
>
> I understand what you want. So I will add emergency_cleanup for host
> driver like this.
> struct mmc_host_ops {
> ................
> .................
> void (*emergency_cleanup)(struct mmc_host *host);
>
> }
>
> When timeout error happen, mmc core will call this function as soon as
> sending stop cmd.
> And when timeout error happen by wait_for_completion_timeout, calling
> mmc_request_done is not needed.
>
> Thanks.
>

I'll follow the opinion of chris.

Thanks.
