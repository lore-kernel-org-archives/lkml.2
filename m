Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2KGLaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:30:21 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64236 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab2KGLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:30:19 -0500
MIME-Version: 1.0
In-Reply-To: <20121107105348.GA25549@lizard>
References: <20121107105348.GA25549@lizard>
Date: Wed, 7 Nov 2012 13:30:16 +0200
X-Google-Sender-Auth: 1VxQeivTyIZJc_Wt7hiBRymlH4g
Message-ID: <CAOJsxLFz+Zi=A0uyuNMj411ngjwpstakNY3fEWy6tW_h4whr7w@mail.gmail.com>
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
From: Pekka Enberg <penberg@kernel.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Wed, Nov 7, 2012 at 12:53 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> This is the third RFC. As suggested by Minchan Kim, the API is much
> simplified now (comparing to vmevent_fd):
>
> - As well as Minchan, KOSAKI Motohiro didn't like the timers, so the
>   timers are gone now;
> - Pekka Enberg didn't like the complex attributes matching code, and
>   so it is no longer there;
> - Nobody liked the raw vmstat attributes, and so they were eliminated
>   too.

I love the API and implementation simplifications but I hate the new
ABI. It's a specialized, single-purpose syscall and bunch of procfs
tunables and I don't see how it's 'extensible' to anything but VM

If people object to vmevent_fd() system call, we should consider using
something more generic like perf_event_open() instead of inventing our
own special purpose ABI.

                        Pekka
