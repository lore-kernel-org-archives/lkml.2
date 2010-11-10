Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0KJSeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:34:31 -0500
Received: from smtp-out.google.com ([74.125.121.35]:52940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab0KJSe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E+BDHMM2m1m+zIR1w1GNUa8Bn5X8xpEb+i7c2hmT96cM+pvhGdt0N37ODrZ4dqyc8d
         v1E76e+GV31KYLuKCXMQ==
MIME-Version: 1.0
In-Reply-To: <1289413457.15905.95.camel@Joe-Laptop>
References: <1289349036-16941-1-git-send-email-davidb@codeaurora.org>
	<1289411969-24650-1-git-send-email-davidb@codeaurora.org>
	<1289413457.15905.95.camel@Joe-Laptop>
Date: Wed, 10 Nov 2010 10:34:25 -0800
Message-ID: <AANLkTi=fBhqvo+xuAMPdkiO0z+K-R5vfS6+P8cf=Yws5@mail.gmail.com>
Subject: Re: [PATCH v3] msm: smd: Reduce driver log chatter
From: Brian Swetland <swetland@google.com>
To: Joe Perches <joe@perches.com>
Cc: David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point, I think we could just drop the printk()s on the init
functions.  They date back from when we first brought up the driver
and I'm not sure they're of much value at all any more.

Brian

On Wed, Nov 10, 2010 at 10:24 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2010-11-10 at 09:59 -0800, David Brown wrote:
>>  arch/arm/mach-msm/smd.c |   18 ++++++++++--------
>
> Hi again David.  More trivia. Ignore at your pleasure.
>
>>  1 files changed, 10 insertions(+), 8 deletions(-)
>> diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
>
> A moderately common kernel style uses macros like:
>
> #define FUNC_ENTER()    pr_debug("--> %s\n", __func__);
> #define FUNC_EXIT()     pr_debug("<-- %s\n", __func__);
> or
> #define FUNC_ENTER()    pr_debug("Enter %s\n", __func__);
> #define FUNC_EXIT()     pr_debug("Exit  %s\n", __func__);
>
> The macro names vary.
> I've seen enter, _enter, kenter, func_enter, etc.
>
>> @@ -939,7 +941,7 @@ int smsm_set_sleep_duration(uint32_t delay)
>>  int smd_core_init(void)
>>  {
>>       int r;
>> -     pr_info("smd_core_init()\n");
>> +     pr_debug("smd_core_init()\n");
>
>        FUNC_ENTER();
>
>> @@ -992,14 +994,14 @@ int smd_core_init(void)
>>       smsm_change_state(SMSM_STATE_APPS_DEM, ~0, 0);
>>  #endif
>>
>> -     pr_info("smd_core_init() done\n");
>> +     pr_debug("smd_core_init() done\n");
>
>        FUNC_EXIT();
>
>>  static int __devinit msm_smd_probe(struct platform_device *pdev)
>>  {
>> -     pr_info("smd_init()\n");
>> +     pr_debug("smd_init()\n");
>
> wrong function name? FUNC_ENTER();
>
>
