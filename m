Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2EGIef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:34:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:48512 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab2EGIee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:34:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com>
References: <20120501132409.GA22894@lizard> <20120501132620.GC24226@lizard>
 <4FA35A85.4070804@kernel.org> <20120504073810.GA25175@lizard> <CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 7 May 2012 04:26:00 -0400
Message-ID: <CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com>
Subject: Re: [PATCH 3/3] vmevent: Implement special low-memory attribute
To: Pekka Enberg <penberg@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Minchan Kim <minchan@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If we'll give up on "1." (Pekka, ping), then we need to solve "2."
>> in a sane way: we'll have to add a 'NR_FILE_PAGES - NR_SHMEM -
>> <todo-locked-file-pages>' attribute, and give it a name.
>
> Well, no, we can't give up on (1) completely. That'd mean that
> eventually we'd need to change the ABI and break userspace. The
> difference between exposing internal details and reasonable
> abstractions is by no means black and white.
>
> AFAICT, RECLAIMABLE_CACHE_PAGES is a reasonable thing to support. Can
> anyone come up with a reason why we couldn't do that in the future?

It can. but the problem is, that is completely useless. Because of, 1)
dirty pages writing-out
is sometimes very slow and 2) libc and some important library's pages
are critical important
for running a system even though it is clean and reclaimable. In other
word, kernel don't have
an info then can't expose it.
