Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab2AQTtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:49:15 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60491 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2AQTtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:49:14 -0500
MIME-Version: 1.0
In-Reply-To: <4F15CC56.90309@redhat.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
	<CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
	<4F15A34F.40808@redhat.com>
	<alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
	<4F15CC56.90309@redhat.com>
Date: Tue, 17 Jan 2012 21:49:13 +0200
X-Google-Sender-Auth: 4GQqt3sCe1EaknGfZT0cpcKpCSQ
Message-ID: <CAOJsxLFzuvYm2pHZP--=nx3qGatzgfT6Dii49gzJwzxOtzniTg@mail.gmail.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
From: Pekka Enberg <penberg@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 9:30 PM, Rik van Riel <riel@redhat.com> wrote:
> Looks like a nice extensible interface to me.
>
> The only thing is, I expect we will not want to wake
> up processes most of the time, when there is no memory
> pressure, because that would just waste battery power
> and/or cpu time that could be used for something else.
>
> The desire to avoid such wakeups makes it harder to
> wake up processes at arbitrary points set by the API.

Sure. You could either bump up the threshold or use Minchan's hooks - or both.

On Tue, Jan 17, 2012 at 9:30 PM, Rik van Riel <riel@redhat.com> wrote:
> Another issue is that we might be running two programs
> on the system, each with a different threshold for
> "lets free some of my cache".  Say one program sets
> the threshold at 20% free/cache memory, the other
> program at 10%.
>
> We could end up with the first process continually
> throwing away its caches, while the second process
> never gives its unused memory back to the kernel.
>
> I am not sure what the right thing to do would be...

One option is to use per-process thresholds on RSS, for example, and
also support system-wide thresholds.

That said, I'd really like to see the N9 and Android policies
supported with this ABI. It's much easier to make it generic once we
support real-world use cases.

                        Pekka
