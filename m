Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2AQJ1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:27:37 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38708 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2AQJ1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:27:34 -0500
MIME-Version: 1.0
In-Reply-To: <1326788038-29141-2-git-send-email-minchan@kernel.org>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
Date: Tue, 17 Jan 2012 11:27:34 +0200
X-Google-Sender-Auth: MIE03H-NsXoVjJmb95iNqA9xgcU
Message-ID: <CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 10:13 AM, Minchan Kim <minchan@kernel.org> wrote:
> +static unsigned int low_mem_notify_poll(struct file *file, poll_table *wait)
> +{
> +        unsigned int ret = 0;
> +
> +        poll_wait(file, &low_mem_wait, wait);
> +
> +        if (atomic_read(&nr_low_mem) != 0) {
> +                ret = POLLIN;
> +                atomic_set(&nr_low_mem, 0);
> +        }
> +
> +        return ret;
> +}

Doesn't this mean that only one application will receive the notification?

                        Pekka
