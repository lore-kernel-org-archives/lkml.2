Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab1CCVTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:19:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53298 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab1CCVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:19:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uPFgtyh/3E9Jxv5Q4mfST1z6sfoT1VV35qxBWv+xhYZLu1S0O+/1yeVWIw6Nsfr6wf
         3eZX6HvKDO9smjd1UeXhZv8mHR/3bqIhs9YqgN2GCMQsldneEJBwoYCKe1TfNa4wR23S
         O8LeGdGHMluoQTKly0Zh98TD5wymmirfiYhiY=
Message-ID: <4D7005D8.7000407@gmail.com>
Date: Thu, 03 Mar 2011 16:19:20 -0500
From: Jinqiu <crindy646@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] Fix bug #13853: dereference pointer 'dev' before null
 check
References: <4D6EFAE5.4000400@gmail.com> <20110303112920.307665dc.rdunlap@xenotime.net>
In-Reply-To: <20110303112920.307665dc.rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11-3-3 下午2:29, Randy Dunlap wrote:
> On Wed, 02 Mar 2011 21:20:21 -0500 Jinqiu wrote:
>
>> This patch fixes bug #13853 .This still exists in latest version.
>> 'dev' is dereferenced before testing for NULL.
>>
>> Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
>> --- a/drivers/net/ariadne.c
>> +++ b/drivers/net/ariadne.c
>> @@ -420,7 +420,7 @@ static inline void ariadne_reset(struct
>> static irqreturn_t ariadne_interrupt(int irq, void *data)
>> {
>> 	struct net_device *dev = (struct net_device *) data;
>> - 	volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
>> + 	volatile struct Am79C960 *lance;
>> 	struct ariadne_private *priv;
>> 	int csr0, boguscnt;
>> 	int handled = 0;
> Did you patch generator tool insert tabs in this patch?
No, I did not. This is weird. The original patch is fine.
  I would fix email client issues.
Thanks for your help! :-)

  Jinqiu
> The line below should be formatted as:
>
> @@ -429,6 +429,7 @@ static irqreturn_t ariadne_interrupt(int
>
> with no space between 429, and 7.
>
>> @@ -429,6 +429, 7 @@ static irqreturn_t ariadne_interrupt(int
>> 		printk(KERN_WARNING  "ariadne_interrupt(): irq for unknown device.\n");
>> 		return IRQ_NONE;
>> 	}
>> + 	lance = (struct Am79C960 *)dev->base_addr;
>>
>> 	lance->RAP = CSR0; 					/* PCnet-ISA Controller Status */
>>
>>
>>
>>
>> --
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

