Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1INLb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 07:31:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36230 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab1INLb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 07:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ0pr1-2K5Emr+Sq4MqcBoYFDRVV9=HE9_A0U72SZrT1DFEy3A@mail.gmail.com>
References: <1315990017-16912-1-git-send-email-per.forlin@linaro.org>
	<1315990017-16912-3-git-send-email-per.forlin@linaro.org>
	<CAC5umygS+viGcG2wAi=7vbjmiQB1jVgwKNAeZxDxB4WMC-teGg@mail.gmail.com>
	<CAJ0pr1-WiLDS-wdb1je81L=tk0TVCbH9eci2YZ=JBp+G7rZ0GQ@mail.gmail.com>
	<CAJ0pr1-2K5Emr+Sq4MqcBoYFDRVV9=HE9_A0U72SZrT1DFEy3A@mail.gmail.com>
Date: Wed, 14 Sep 2011 13:31:25 +0200
Message-ID: <CAJ0pr186Q-Yk=O8PEJYBDijFoj3AAUNLoZexbXqb9t8czCp86A@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mmc: add module param to set fault injection attributes
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linaro-dev@lists.linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2011 12:38, Per Forlin <per.forlin@linaro.org> wrote:
> On 14 September 2011 12:18, Per Forlin <per.forlin@linaro.org> wrote:
>> On 14 September 2011 12:05, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>>> 2011/9/14 Per Forlin <per.forlin@linaro.org>:
>>>
>>>> +#ifdef CONFIG_FAIL_MMC_REQUEST
>>>> +
>>>> +static DECLARE_FAULT_ATTR(fail_default_attr);
>>>> +static char *fail_request;
>>>
>>> This is not used anymore and ...
>>>
>> Yes of course. Will remove it.
>>
>>>> +static int fail_mmc_request_param_set(const char *val,
>>>> +                                     const struct kernel_param *kp)
>>>> +{
>>>> +       setup_fault_attr(&fail_default_attr, (char *) val);
> I am thinking of returning failure here if setup_fault_attr() fails.
> if (setup_fault_attr(&fail_default_attr, (char *) val) == 0)
>  return -EINVAL;
>
> There will be a printk(KERN_WARNING "FAULT_INJECTION: failed to parse
> arguments) it setup() fails. Is it too harsh to return failure?
>
If error is returned here the kernel prints: "invalid for parameter
`mmc_core.fail_request'"
This piece of information is a reason for returning error on failure.

Regards,
Per
