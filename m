Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2EHJ1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:27:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33656 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2EHJ1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:27:41 -0400
MIME-Version: 1.0
In-Reply-To: <4FA8DA23.3030609@kernel.org>
References: <20120501132409.GA22894@lizard>
	<20120501132620.GC24226@lizard>
	<4FA35A85.4070804@kernel.org>
	<20120504073810.GA25175@lizard>
	<CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com>
	<CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com>
	<20120507121527.GA19526@lizard>
	<4FA82056.2070706@gmail.com>
	<CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
	<CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
	<CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
	<CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<4FA8DA23.3030609@kernel.org>
Date: Tue, 8 May 2012 12:27:40 +0300
X-Google-Sender-Auth: E2GiTy3eIIQrnDFpHZrWIqD_nA4
Message-ID: <CAOJsxLGGCq7czaBBO0POeWoh77ne5EXGs1+dxuSp1rj3Leydiw@mail.gmail.com>
Subject: Re: [PATCH 3/3] vmevent: Implement special low-memory attribute
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 11:32 AM, Minchan Kim <minchan@kernel.org> wrote:
> The idea is that we can make some levels in advane and explain it to user
>
> Level 1: It a immediate response to user when kernel decide there are not fast-reclaimable pages any more.
> Level 2: It's rather slower response than level 1 but kernel will consider it as reclaimable target
> Level 3: It's slowest response because kernel will consider page needed long time to reclaim as reclaimable target.
>
> It doesn't expose any internal of kernel and can implment it in internal.
> For simple example,
>
> Level 1: non-mapped clean page
> Level 2: Level 1 + mapped clean-page
> Level 3: Level 2 + dirty pages
>
> So users of vmevent_fd can select his level.

I'm totally OK with pursuing something like this if people like Leonid
and Anton think it's useful for their use-cases.
