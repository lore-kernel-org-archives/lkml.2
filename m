Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1EAMBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 08:01:46 -0400
Received: from acoma.acyna.com ([72.9.254.68]:43086 "EHLO acoma.acyna.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab1EAMBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 08:01:43 -0400
X-Greylist: delayed 2062 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 May 2011 08:01:43 EDT
Message-ID: <4DBD4394.20907@hubstar.net>
Date: Sun, 01 May 2011 12:27:16 +0100
From: linuxtv <linuxtv@hubstar.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Andi Huber <hobrom@gmx.at>, Marlon de Boer <marlon@hyves.nl>,
        Damien Churchill <damoxc@gmail.com>
Subject: Re: [PATCH v2.6.38 resend 0/7] cx88 deadlock and data races
References: <20110501091710.GA18263@elie>
In-Reply-To: <20110501091710.GA18263@elie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - acoma.acyna.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - hubstar.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI I too experienced the problem of hanging and used the patch dated
6th April to get it working.
However I do have the problem that sound does not always work/come on.
Once it is started it stays, getting it started is not reliable.

On 01/05/11 10:17, Jonathan Nieder wrote:
> Hi,
>
> Since v2.6.37 (BKL removal), trying to open a cx88-blackbird driven
> MPEG device would hang.  Ben Hutchings provided an initial patch[1] to
> fix that, and Andi Huber helped a lot in finding races that patch had
> missed.  Ben requested that I take authorship of the series, so I've
> done so.
>
> These patches have visited the list twice before[2], towards the
> beginning of this month.  No feedback from maintainers or reviewers
> --- I'm beginning to wonder if I have the right list.  Luckily two
> people[3][4] experiencing this problem on bugzilla were kind enough to
> test the series and found it worked okay.
>
> Patches are against v2.6.38 (but they do not conflict with anything in
> media-tree/staging/for_v2.6.40).  The intent is to include them in
> v2.6.40 if possible.  A copy of these patches is also available for
> convenient fetching from
>
>   git://repo.or.cz/linux-2.6/jrn.git cx88-locking
>
> Thoughts?
>
> Jonathan Nieder (7):
>   [media] cx88: protect per-device driver list with device lock
>   [media] cx88: fix locking of sub-driver operations
>   [media] cx88: hold device lock during sub-driver initialization
>   [media] cx88: protect cx8802_devlist with a mutex
>   [media] cx88: gracefully reject attempts to use unregistered
>     cx88-blackbird driver
>   [media] cx88: don't use atomic_t for core->mpeg_users
>   [media] cx88: don't use atomic_t for core->users
>
>  drivers/media/video/cx88/cx88-blackbird.c |   41 +++++++++++++++-------------
>  drivers/media/video/cx88/cx88-dvb.c       |    2 +
>  drivers/media/video/cx88/cx88-mpeg.c      |   40 ++++++++++++++++++----------
>  drivers/media/video/cx88/cx88-video.c     |    5 ++-
>  drivers/media/video/cx88/cx88.h           |   11 +++++--
>  5 files changed, 61 insertions(+), 38 deletions(-)
>
> [1] http://bugs.debian.org/619827
> [2] http://thread.gmane.org/gmane.linux.kernel/1118815
> [3] https://bugzilla.kernel.org/show_bug.cgi?id=31792
> [4] https://bugzilla.kernel.org/show_bug.cgi?id=31962
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

