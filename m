Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1FJJvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:51:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55997 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1FJJvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:51:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jqTZ7o4UMf0jR9DWozkBO7Y6vaNcB2MMF+Xs1IqWNE26gvuI7KAYT2JDInnJKSO4gU
         +tDTAieA0Fy9Mzhb+sigv6HE6MElOQ1Rv0LnuH34MAyp91mzi2DJUpUJCRrNXs5j4lIs
         9Ma4n5haGWaBPD532kcVLuecwmS2Z6MGaNdFA=
MIME-Version: 1.0
In-Reply-To: <BANLkTikAvnam2WNTBMj_J5yBHrxJxSjLuw@mail.gmail.com>
References: <201106082045.p58Kjwmd027729@imap1.linux-foundation.org>
	<BANLkTikAvnam2WNTBMj_J5yBHrxJxSjLuw@mail.gmail.com>
Date: Fri, 10 Jun 2011 17:51:50 +0800
Message-ID: <BANLkTimPT-LEsEs34dvPZNbVKnwCT8ck6g@mail.gmail.com>
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler-update.patch added to
 -mm tree
From: Dave Young <hidave.darkstar@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 1:19 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Wed, Jun 8, 2011 at 11:45 PM,  <akpm@linux-foundation.org> wrote:
>> --- a/kernel/sysctl.c~sysctl-add-proc_dointvec_unsigned-handler-update
>> +++ a/kernel/sysctl.c
>> @@ -2515,6 +2515,7 @@ int proc_dointvec_unsigned(struct ctl_ta
>>  {
>>        struct do_proc_dointvec_minmax_conv_param param = {
>>                .min = &zero,
>> +               .max = (int *) table->extra2,
>>        };
>>        return do_proc_dointvec(table, write, buffer, lenp, ppos,
>>                                do_proc_dointvec_minmax_conv, &param);
>
> This is still buggybecause "zero" is only 1 variable and max can be an array.
> Sysctl boundary comparisons are done element-by-element.

Where's the array use case?

-- 
Regards
dave
