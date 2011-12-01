Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1LAKrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:47:13 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:59994 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751320Ab1LAKrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:47:12 -0500
Message-ID: <4ED75AF3.2090901@ru.mvista.com>
Date: Thu, 01 Dec 2011 14:46:11 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        JBottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] arm: prevent inlining in arxescsi.c causing build failures
References: <1322713611-30003-1-git-send-email-paul.gortmaker@windriver.com> <20111201080613.GF26618@pengutronix.de>
In-Reply-To: <20111201080613.GF26618@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01.12.2011 12:06, Uwe Kleine-König wrote:

>> The following failure is seen in routine coverage builds:

>>    CC [M]  drivers/scsi/arm/arxescsi.o
>> /tmp/cccEyiO7.s: Assembler messages:
>> /tmp/cccEyiO7.s:334: Error: symbol `.loop_1' is already defined
>> /tmp/cccEyiO7.s:337: Error: symbol `.loop_2' is already defined
>> /tmp/cccEyiO7.s:343: Error: symbol `.loop_3' is already defined
>> /tmp/cccEyiO7.s:365: Error: symbol `.loop_1' is already defined
>> /tmp/cccEyiO7.s:368: Error: symbol `.loop_2' is already defined
>> /tmp/cccEyiO7.s:374: Error: symbol `.loop_3' is already defined
>> make[4]: *** [drivers/scsi/arm/arxescsi.o] Error 1

>> It is caused by multiple inline of arxescsi_pseudo_dma_write()
>> which is responsible for the above labels.  Marking the fcn
>> as non-inline fixes the issue.

>> Signed-off-by: Paul Gortmaker<paul.gortmaker@windriver.com>

> Is that a compiler or a code issue? If it's the compiler please fix
> that. If it's the code, then please document why you added the noinline.

> Having said that, "my" compiler compiles drivers/scsi/arm/arxescsi.o
> just fine (using rpc_defconfig on v3.2-rc2).

>> diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
>> index a750aa7..2608a9e 100644
>> --- a/drivers/scsi/arm/arxescsi.c
>> +++ b/drivers/scsi/arm/arxescsi.c
>> @@ -72,7 +72,8 @@ arxescsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
>>   	return fasdma_pseudo;
>>   }
>>
>> -static void arxescsi_pseudo_dma_write(unsigned char *addr, void __iomem *base)
>> +static noinline void
>> +arxescsi_pseudo_dma_write(unsigned char *addr, void __iomem *base)

> Shouldn't this line get some indention?

    No, usually such lines don't get indented.

WBR, Sergei

