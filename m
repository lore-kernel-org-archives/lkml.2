Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334Ab2CTOtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:49:08 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57980 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760127Ab2CTOtE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <37CAE120BAE10B42A790DD1418C8021D0136C7@DNCE02.ent.ti.com>
References: <1316475315-5905-1-git-send-email-khilman@ti.com>
	<87d3d75zo6.fsf@ti.com>
	<4EBA6046.2060305@linux.vnet.ibm.com>
	<37CAE120BAE10B42A790DD1418C8021D0136C7@DNCE02.ent.ti.com>
Date: Tue, 20 Mar 2012 20:19:02 +0530
Message-ID: <CAHSGOuuexpCDNoP1G1Gyge2DCep0rsPmUwrVyZFDQ1_tH+Du7Q@mail.gmail.com>
Subject: Re: [PATCH] CPUIdle: Reevaluate C-states under CPU load to favor
 deeper C-states
From: melwyn lobo <linux.melwyn@gmail.com>
To: "Chalhoub, Nicole" <n-chalhoub@ti.com>, "Hilman, Kevin" <khilman@ti.com>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Kevin,
I would like to try out this patch in my platform see the benefits
that you are reporting. But there is one issue in this patch. You have
not initialized "hrtimer_timeout" variable.
This will always be 0 right ?.
Thanks,
-M

On Wed, Nov 9, 2011 at 11:36 PM, Chalhoub, Nicole <n-chalhoub@ti.com> wrote:
> Hi Deepthi,
>
>>
> Texas Instruments France SA, 821 Avenue Jack Kilby, 06270 Villeneuve Loubet. 036 420 040 R.C.S Antibes. Capital de EUR 753.920
>
> -----Original Message-----
>> From: Deepthi Dharwar [mailto:deepthi@linux.vnet.ibm.com]
>> Sent: Wednesday, November 09, 2011 12:13 PM
>> To: Hilman, Kevin
>> Cc: linux-kernel@vger.kernel.org; Arjan van de Ven; linux-arm-
>> kernel@lists.infradead.org; linux-omap@vger.kernel.org; linux-
>> pm@lists.linux-foundation.org; Chalhoub, Nicole
>> Subject: Re: [PATCH] CPUIdle: Reevaluate C-states under CPU load to favor
>> deeper C-states
>
> [...]
>> By setting timers when we enter non-deepest C-state possible, such that
>> when it fires we
>> can re-evaluate and try moving into deeper and deeper C-states enhancing
>> the
>> power savings is a good feature to have.
>>
>> Looking at the current implementation, is it possible to have it as
>> configurable option
>> where one can enable/disable this functionality through the backhand
>> driver ?
>
> The timeout values of the c state timers are set in the backhand driver.
> By setting the timeout to 0 the timers will not fire so you'll not have this functionality enabled
>
>> Also I am thinking, instead of having them in governor
>> wouldnt it be a good idea to have it implemented in
>> the backhand driver itself ?
>> --Deepthi
>
>
> In fact each C-state had its own configurable timer, so it is a parameter characterizing a C-state as it is for the exit_latency and target_residency parameters.
> And we wanted the timer to fire only when we do not go in deep Cstate due to a high load. This decision is made in the CPU idle governor. So the functionality should be seen from the governor..
>
> Thanks and Regards
> Nicole
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
