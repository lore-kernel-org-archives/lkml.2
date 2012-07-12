Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab2GLJHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:07:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64316 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab2GLJHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120712094943.2aba6d33@pyramind.ukuu.org.uk>
References: <1342073368-11893-1-git-send-email-devendra.aaru@gmail.com>
	<20120712094943.2aba6d33@pyramind.ukuu.org.uk>
Date: Thu, 12 Jul 2012 14:52:37 +0545
Message-ID: <CAHdPZaPhi+53qCHkJXPOP7XQcd1DKnXr=gpcdhsH3YbUq2=h9A@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging/et131x: remove memset for the TCB
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Francois Romieu <romieu@fr.zoreil.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 2:34 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 12 Jul 2012 11:54:28 +0545
> Devendra Naga <devendra.aaru@gmail.com> wrote:
>
>> TCB has kcalloc' ed so no need to call memset again on it.
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>> ---
>>  drivers/staging/et131x/et131x.c |    2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
>> index 227fca9..5010894 100644
>> --- a/drivers/staging/et131x/et131x.c
>> +++ b/drivers/staging/et131x/et131x.c
>> @@ -2131,8 +2131,6 @@ static void et131x_init_send(struct et131x_adapter *adapter)
>>
>>       tx_ring->tcb_qhead = tcb;
>>
>> -     memset(tcb, 0, sizeof(struct tcb) * NUM_TCB);
>
> Its such a rarely used path with several entry points that it's probably
> safer kept as is.
>
Hi Alan Sir,

 Glad to see your reply, I really didn't saw the whole code paths, was
seeing the ring allocations, sorry for the noise.
> Alan

Thanks,
Devendra.
