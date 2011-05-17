Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab1EQRGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:06:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab1EQRGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:06:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KYRlGrCfxjJ7r8rpqSrJjjCQEK80O+hxkdIAE31Kc5p7kdP5zrv3UPqT7kG4ieh8j8
         wwd1YbJzAhtOKkpFruJA==
MIME-Version: 1.0
In-Reply-To: <4DD27F7D.2070305@ti.com>
References: <1305588114-23728-1-git-send-email-ccross@android.com>
	<4DD27F7D.2070305@ti.com>
Date: Tue, 17 May 2011 10:06:07 -0700
X-Google-Sender-Auth: I3ojBzgtOKw2mSEff55w5go3weI
Message-ID: <BANLkTinUxn_szHVHSKOZ1WJAckmo9mSudA@mail.gmail.com>
Subject: Re: [PATCH] ARM: smp_twd: Reconfigure clockevents after cpufreq change
From: Colin Cross <ccross@android.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-arm-kernel@lists-infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 7:00 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> Colin,
>
> On 5/17/2011 4:51 AM, Colin Cross wrote:
>>
>> The localtimer's clock changes with the cpu clock.  After a
>> cpufreq transition, update the clockevent's frequency and
>> reprogram the next clock event.
>>
>> Adds a clock called "smp_twd" that is used to determine the
>> twd frequency, which can also be used at init time to
>> avoid calibrating the twd frequency.
>>
>> Signed-off-by: Colin Cross<ccross@android.com>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> Cc: Russell King<linux@arm.linux.org.uk>
>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>> Cc: Rob Herring<robherring2@gmail.com>
>> ---
>>  arch/arm/kernel/smp_twd.c |   69
>> +++++++++++++++++++++++++++++++++++++++++++--
>>  1 files changed, 66 insertions(+), 3 deletions(-)
>>
>> This patch depends on Thomas Gleixner's patch to add
>> clockevents_reconfigure
>> See: https://lkml.org/lkml/2011/5/13/122
>>
>> This patch adds a clock that can be used to skip calibration as well
>> as update the frequency.  A later patch (or a later version of this patch)
>> will drop twd_calibrate_rate once all platforms provide the necessary
>> smp_twd clock.
>>
>
> Since the "smp_twd" clock node will not have a clk_set_rate()
> associated with it, will the clk_get_rate() gives you real
> rate. May be we can associate this node as a child of
> CPU clock node and use the fixed divider based on peripheral
> ratio. Is that the idea here to realize it ?

Yes, the idea is that it will be a fixed divider off the cpu clock,
which will have been updated by cpufreq.
