Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0J1LsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:48:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37835 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab0J1LsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=aVb6AhDsfGpYDcrO/6rWkVuc+zuDLQbGOFgUE/CqLY/y3K7yskn74QyXA6vICA+KbA
         kWiMTYUvpyUo7A9UOomapmDeapMeJ8OQSy0OMahXQ4vZYWSs5nuEhrtDtCXZx0XDsYQf
         VT8A8mipfTvt5MuWs35Miag+i90uS9WM1dfac=
MIME-Version: 1.0
In-Reply-To: <AANLkTikyYQk1FH7d6jkw2GYHLN8jmghuGZQw=EFVgjuA@mail.gmail.com>
References: <AANLkTimt7wzR9RwGWbvhiOmot_zzayfCfSh_-v6yvuAP@mail.gmail.com>
	<AANLkTikRKVBzO=ruy=JDmBF28NiUdJmAqb4-1VhK0QBX@mail.gmail.com>
	<AANLkTinzJ9a+9w7G5X0uZpX2o-L8E6XW98VFKoF1R_-S@mail.gmail.com>
	<AANLkTinDDG0ZkNFJZXuV9k3nJgueUW=ph8AuHgyeAXji@mail.gmail.com>
	<AANLkTikvSGNE7uGn5p0tfJNg4Hz5WRmLRC8cXu7+GhMk@mail.gmail.com>
	<20101028090002.GA12446@elte.hu>
	<AANLkTinoGGLTN2JRwjJtF6Ra5auZVg+VSa=TyrtAkDor@mail.gmail.com>
	<AANLkTikyYQk1FH7d6jkw2GYHLN8jmghuGZQw=EFVgjuA@mail.gmail.com>
Date: Thu, 28 Oct 2010 14:48:20 +0300
X-Google-Sender-Auth: q19xVEYdRjCoi5dexmiU280K97o
Message-ID: <AANLkTikx4zZwMLiAUrGKcH6yoo_PGgRA7nT9BzYMxQ89@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
From: Pekka Enberg <penberg@kernel.org>
To: Aidar Kultayev <the.aidar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, npiggin@kernel.dk,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 2:33 PM, Aidar Kultayev <the.aidar@gmail.com> wrote:
> if it wasn't picasa, it would have been something else. I mean if I
> kill picasa ( later on it was done indexing new pics anyway ), it
> would have been for virtualbox to thrash the io. So, nope, getting rid
> of picasa doesn't help either. In general the systems responsiveness
> or sluggishness is dominated by those io operations going on - the DD
> & CP & probably VBOX issuing whole bunch of its load for IO.

Do you still see high latencies in vfs_lseek() and vfs_fsync()? I'm
not a VFS expert but looking at your latencytop output, it seems that
fsync grabs ->i_mutex which blocks vfs_llseek(), for example. I'm not
sure why that causes high latencies though it's a mutex we're holding.

On Thu, Oct 28, 2010 at 2:33 PM, Aidar Kultayev <the.aidar@gmail.com> wrote:
> Another way I see these delays, is when I leave system overnight, with
> ktorrent & juk(stopped) in the background. It takes some time for
> WM(kwin) to work out ALT+TAB the very next morning. But this might be
> because the WM(kwin & its code) has been swapped out, because of long
> period of not using it.

Yeah, that's probably paging overhead.

P.S. Can you please upload latencytop output somewhere and post an URL
to it so other people can also see it?
