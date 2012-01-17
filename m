Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2AQJpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:45:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50690 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2AQJpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:45:08 -0500
MIME-Version: 1.0
In-Reply-To: <1326788038-29141-2-git-send-email-minchan@kernel.org>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
Date: Tue, 17 Jan 2012 11:45:06 +0200
X-Google-Sender-Auth: 7EAPFb8nEQXCshxJt5giJF9Ym8Q
Message-ID: <CAOJsxLFdm_vLcuWzzcC==JTpVERuf4XNUOqvRyLt=Q0ixqmx7A@mail.gmail.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        leonid.moiseichuk@nokia.com, kamezawa.hiroyu@jp.fujitsu.com,
        Rik van Riel <riel@redhat.com>, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 10:13 AM, Minchan Kim <minchan@kernel.org> wrote:
> This patch makes new device file "/dev/low_mem_notify".
> If application polls it, it can receive event when system
> memory pressure happens.
>
> This patch is based on KOSAKI and Marcelo's long time ago work.
> http://lwn.net/Articles/268732/

I'm not loving the ABI. Alternative solutions:

  - SIGDANGER + signalfd() for poll

  - sys_eventfd()

  - sys_mem_notify_open() similar to sys_perf_event_open()

                        Pekka
