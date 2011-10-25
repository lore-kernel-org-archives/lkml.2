Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1JYPzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab1JYPzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:55:18 -0400
Date: Tue, 25 Oct 2011 11:55:01 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-cifs@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the cifs tree
Message-ID: <20111025115501.1471db86@corrin.poochiereds.net>
In-Reply-To: <CAH2r5muLiYKCrS2f_DftZSnyuP0EC+vu99mENznCSL8ecnTkpg@mail.gmail.com>
References: <20111026005939.ad20ab7a2dacce216c69e821@canb.auug.org.au>
	<CAH2r5muLiYKCrS2f_DftZSnyuP0EC+vu99mENznCSL8ecnTkpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 09:51:37 -0500
Steve French <smfrench@gmail.com> wrote:

> Am fixing it now.  Jeff missed a stub for the non-freezer case.
> 
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index a155561..cd2d55b 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -202,6 +202,8 @@ static inline void set_freezable_with_signal(void) {}
> 
>  #define wait_event_freezable_timeout(wq, condition, timeout)		\
>  		wait_event_interruptible_timeout(wq, condition, timeout)
> +#define #define wait_event_freezekillable(wq, condition)		\
> +		wait_event_killable(wq, condition)
> 
> 

Yep, silly oversight on my part -- sorry about that. That's exactly
what I was planning to do, so you can add my acked-by on that patch...

Thanks,
Jeff


> On Tue, Oct 25, 2011 at 8:59 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > After merging the cifs tree, today's linux-next build (powerpc
> > iseries_defconfig) failed like this:
> >
> > fs/cifs/transport.c: In function 'wait_for_response':
> > fs/cifs/transport.c:328: error: implicit declaration of function 'wait_event_freezekillable'
> >
> > Caused by commit f06ac72e9291 ("cifs, freezer: add
> > wait_event_freezekillable and have cifs use it").  In this config,
> > CONFIG_FREEZER is not set.
> > --
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > http://www.canb.auug.org.au/~sfr/
> >
> 
> 
> 


-- 
Jeff Layton <jlayton@redhat.com>
