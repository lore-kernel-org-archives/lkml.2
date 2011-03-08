Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1CHFne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 00:43:34 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56688 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab1CHFnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 00:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RvqqxYI+jjWY42E5fNhI2nuAjf4731U/fcsAQgxa2Ru7Nb71zs1HzCdWITnRxPe6Ut
         VfCXMMqjTohs9ewkYwaM+NByOw9kYH4pDFCQ2udHOMs6WVQpOLEJytK6kGPikcRo/KPM
         +92Zpc/61WHVKNFJJ/N/422KnsQSRLG5MKXk8=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=-PcbpBjWZuno1fjwZD-tGmC+JMxrzMr1FNwu7@mail.gmail.com>
References: <201103072305.p27N5hKT000474@imap1.linux-foundation.org>
	<20110307232655.GA7234@p183.telecom.by>
	<AANLkTi=-PcbpBjWZuno1fjwZD-tGmC+JMxrzMr1FNwu7@mail.gmail.com>
Date: Tue, 8 Mar 2011 13:43:31 +0800
Message-ID: <AANLkTikxbAfpHCWzvLscdHccOju=Q1tN0pvcu_=jbeQ_@mail.gmail.com>
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler.patch added to -mm tree
From: Dave Young <hidave.darkstar@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 1:15 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Tue, Mar 8, 2011 at 7:26 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> On Mon, Mar 07, 2011 at 03:05:43PM -0800, akpm@linux-foundation.org wrote:
>>> Add a proc_dointvec_unsigned() sysctl handler for positive value cases.
>>
>>> --- a/kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler
>>> +++ a/kernel/sysctl.c
>>
>>> +int proc_dointvec_unsigned(struct ctl_table *table, int write,
>>> +               void __user *buffer, size_t *lenp, loff_t *ppos)
>>> +{
>>> +     struct do_proc_dointvec_minmax_conv_param param = {
>>> +             .min = &zero,
>>> +     };
>>> +     return do_proc_dointvec(table, write, buffer, lenp, ppos,
>>> +                             do_proc_dointvec_minmax_conv, &param);
>>> +}
>>
>> This silently ignored max value in .extra2 .
>
> Hi,
>
> Good cache, should set .max = NULL here

Oh, c99 set default value to 0, isn't it?

What do you mean silently ignore here?

Let's see the code:

 if ((param->min && *param->min > val) ||
                    (param->max && *param->max < val))
                    return -EINVAL;

There's no problem max == NULL

-- 
Regards
dave
