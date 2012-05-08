Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2EHIOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:14:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50677 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2EHIOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:14:32 -0400
Date: Tue, 8 May 2012 01:13:06 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Minchan Kim <minchan@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 3/3] vmevent: Implement special low-memory attribute
Message-ID: <20120508081305.GA20574@lizard>
References: <4FA35A85.4070804@kernel.org>
 <20120504073810.GA25175@lizard>
 <CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com>
 <CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com>
 <20120507121527.GA19526@lizard>
 <4FA82056.2070706@gmail.com>
 <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
 <CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
 <20120508065829.GA13357@lizard>
 <4FA8C86B.8010205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FA8C86B.8010205@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 03:16:59AM -0400, KOSAKI Motohiro wrote:
[...]
> >So, feel free to call me an idiot, but please expand your points a
> >little bit or give a link to the discussion you're referring to?
> 
> I don't think you are idiot. But I hope you test your patch before submitting.
> That just don't work especially on x86. Because of, all x86 box have multiple zone
> and summarized statistics (i.e. global_page_state() thing) don't work and can't
> prevent oom nor swapping.

Now I think I understand you: we don't take into account that e.g. DMA
zone is not usable by the normal allocations, and so if we're basing our
calculations on summarized stats, it is indeed possible to get an OOM
in such a case. On Android kernels nobody noticed the issue as it is
used mainly on ARM targets, which might have CONFIG_ZONE_DMA=n.

So, this particular issue makes sense now.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
