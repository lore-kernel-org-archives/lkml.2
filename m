Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab2FHIsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:48:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48112 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933872Ab2FHIsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <4FD1BB29.1050805@kernel.org>
References: <CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
	<20120601122118.GA6128@lizard>
	<alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
	<4FCC7592.9030403@kernel.org>
	<20120604113811.GA4291@lizard>
	<4FCD14F1.1030105@gmail.com>
	<CAOJsxLHR4wSgT2hNfOB=X6ud0rXgYg+h7PTHzAZYCUdLs6Ktug@mail.gmail.com>
	<20120605083921.GA21745@lizard>
	<4FD014D7.6000605@kernel.org>
	<20120608074906.GA27095@lizard>
	<4FD1BB29.1050805@kernel.org>
Date: Fri, 8 Jun 2012 11:48:06 +0300
X-Google-Sender-Auth: Y0HphNQeIAwhB8UbMX0JzQuOFiM
Message-ID: <CAOJsxLHPvg=bsv+GakFGHyJwH0BoGA=fmzy5bwqWKNGryYTDtg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Some vmevent fixes...
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 11:43 AM, Minchan Kim <minchan@kernel.org> wrote:
>> So, the solution would be then two-fold:
>>
>> 1. Use your memory pressure notifications. They must be quite fast when
>>    we starting to feel the high pressure. (I see the you use
>>    zone_page_state() and friends, which is vm_stat, and it is updated
>
> VM has other information like nr_reclaimed, nr_scanned, nr_congested, recent_scanned,
> recent_rotated, too. I hope we can make math by them and improve as we improve
> VM reclaimer.
>
>>    very infrequently, but to get accurate notification we have to
>>    update it much more frequently, but this is very expensive. So
>>    KOSAKI and Christoph will complain. :-)
>
>
> Reclaimer already have used that and if we need accuracy, we handled it
> like zone_watermark_ok_safe. If it's very inaccurate, VM should be fixed, too.

Exactly. I don't know why people think pushing vmevents to userspace
is going to fix any of the hard problems.

Anton, Lenoid, do you see any fundamental issues from userspace point
of view with going forward what Minchan is proposing?
