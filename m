Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab2EBG5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:57:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57225 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2EBG5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:57:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FA0C042.9010907@kernel.org>
References: <20120418083208.GA24904@lizard>
	<20120418083523.GB31556@lizard>
	<alpine.LFD.2.02.1204182259580.11868@tux.localdomain>
	<20120418224629.GA22150@lizard>
	<alpine.LFD.2.02.1204190841290.1704@tux.localdomain>
	<20120419162923.GA26630@lizard>
	<20120501131806.GA22249@lizard>
	<4FA04FD5.6010900@redhat.com>
	<20120502002026.GA3334@lizard>
	<4FA08BDB.1070009@gmail.com>
	<20120502033136.GA14740@lizard>
	<4FA0C042.9010907@kernel.org>
Date: Wed, 2 May 2012 09:57:05 +0300
X-Google-Sender-Auth: NpTZ9M3sWc1V5D7LrZ1SqJT-K5M
Message-ID: <CAOJsxLHdy8pBCBmbYfiHL681Bd=p_XPXjJHgVKqhT9nYquAjOg@mail.gmail.com>
Subject: Re: [PATCH v4] vmevent: Implement greater-than attribute state and
 one-shot mode
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Glauber Costa <glommer@parallels.com>, kamezawa.hiroyu@jp.fujitsu.com,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 8:04 AM, Minchan Kim <minchan@kernel.org> wrote:
> I think hardest problem in low mem notification is how to define _lowmem situation_.
> We all guys (server, desktop and embedded) should reach a conclusion on define lowmem situation
> before progressing further implementation because each part can require different limits.
> Hopefully, I want it.
>
> What is the best situation we can call it as "low memory"?

Looking at real-world scenarios, it seems to be totally dependent on
userspace policy.

On Wed, May 2, 2012 at 8:04 AM, Minchan Kim <minchan@kernel.org> wrote:
> As a matter of fact, if we can define it well, I think even we don't need vmevent ABI.
> In my opinion, it's not easy to generalize each use-cases so we can pass it to user space and
> just export low attributes of vmstat in kernel by vmevent.
> Userspace program can determine low mem situation well on his environment with other vmstats
> when notification happens. Of course, it has a drawback that userspace couples kernel's vmstat
> but at least I think that's why we need vmevent for triggering event when we start watching carefully.

Please keep in mind that VM events is not only about "low memory"
notification. The ABI might be useful for other kinds of VM events as
well.
