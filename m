Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab2DJLXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 07:23:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38554 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2DJLXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 07:23:43 -0400
Message-ID: <4F8417DB.3040502@mvista.com>
Date: Tue, 10 Apr 2012 15:22:03 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thang Nguyen <tqnguyen@apm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jeff Garzik <jgarzik@pobox.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/1] Add support 2 SATA ports for Maui and change filename
 from sata_dwc_460ex.c to sata_dwc_4xx.c
References: <1333447938-16461-1-git-send-email-tqnguyen@apm.com> <4F82B61D.8010502@mvista.com> <8a0ea5bd221ddeb9eded16e180aa8fbb@mail.gmail.com>
In-Reply-To: <8a0ea5bd221ddeb9eded16e180aa8fbb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-04-2012 7:46, Thang Nguyen wrote:

> Hi Sergei,
> Thanks for your review.

> On Maui, there are 2 separate SATA controllers but they share the same
> AHBDMA controller. Each SATA controller is assigned a fixed DMA channel on
> the AHBDMA (channel 0 is assigned to SATA controller 0 and channel 1 is
> assigned to SATA controller 1).
> For the 460EX, there is only 1 SATA controller and it uses channel 0 for
> transferring data.

> In my opinion, in the case of Maui, we can use the same DMA information in
> 2 device nodes as they use the same DMA controller. And in another CPU, if
> they use different DMA controller, the corresponding information will also
> be different.

    No, either the DMA controller should be a separate device node, or both 
ports and DMA controller should be packed into the single device node. The way 
you're doing it is incorrect because it creates memory resource conflict 
between devices when they are instantiated as platfrom devices.

> Regards,
> Thang Nguyen -
> -----Original Message-----
> From: Sergei Shtylyov [mailto:sshtylyov@mvista.com]
> Sent: Monday, April 09, 2012 5:13 PM
> To: Thang Q. Nguyen
> Cc: Benjamin Herrenschmidt; Paul Mackerras; Jeff Garzik; Grant Likely; Rob
> Herring; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> linux-ide@vger.kernel.org; devicetree-discuss@lists.ozlabs.org
> Subject: Re: [PATCH 1/1] Add support 2 SATA ports for Maui and change
> filename from sata_dwc_460ex.c to sata_dwc_4xx.c

> Hello.

> On 03-04-2012 14:12, Thang Q. Nguyen wrote:

>> Signed-off-by: Thang Q. Nguyen<tqnguyen@apm.com>
> [...]

>> diff --git a/arch/powerpc/boot/dts/bluestone.dts
> b/arch/powerpc/boot/dts/bluestone.dts
>> index cfa23bf..803fda6 100644
>> --- a/arch/powerpc/boot/dts/bluestone.dts
>> +++ b/arch/powerpc/boot/dts/bluestone.dts
>> @@ -155,6 +155,27 @@
>>    					/*RXDE*/  0x5 0x4>;
>>    		};
>>
>> +		/* SATA DWC devices */
>> +		SATA0: sata@bffd1000 {
>> +			compatible = "amcc,sata-apm821xx";
>> +			reg =<4 0xbffd1000 0x800   /* SATA0 */
>> +			       4 0xbffd0800 0x400>; /* AHBDMA */
>> +			dma-channel=<0>;
>> +			interrupt-parent =<&UIC0>;
>> +			interrupts =<26 4    /* SATA0 */
>> +			              25 4>;  /* AHBDMA */
>> +		};
>> +
>> +		SATA1: sata@bffd1800 {
>> +			compatible = "amcc,sata-apm821xx";
>> +			reg =<4 0xbffd1800 0x800   /* SATA1 */
>> +			       4 0xbffd0800 0x400>; /* AHBDMA */
>> +			dma-channel=<1>;
>> +			interrupt-parent =<&UIC0>;
>> +			interrupts =<27 4    /* SATA1 */
>> +			              25 4>;  /* AHBDMA */
>> +		};
>> +

>      So, this is dual SATA controller, not dual port SATA controller?
> BTW, it's wrong to have the same AHBDMA resource in two device nodes I
> think.

> MBR, Sergei

    Can you get rid of the following? It looks stupid when you post to the 
maliing list.

> CONFIDENTIALITY NOTICE: This e-mail message, including any attachments,
> is for the sole use of the intended recipient(s) and contains information
> that is confidential and proprietary to AppliedMicro Corporation or its subsidiaries.
> It is to be used solely for the purpose of furthering the parties' business relationship.
> All unauthorized review, use, disclosure or distribution is prohibited.
> If you are not the intended recipient, please contact the sender by reply e-mail
> and destroy all copies of the original message.

WBR, Sergei
