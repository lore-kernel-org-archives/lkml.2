Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab0J3Ouv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:50:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50481 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab0J3Ous (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=KowawcFobUOFSn62iDGMl8FDreWEri0OaM21m8inJOQna6h+futjok1Yl9rQ/rXGMf
         qi3EAh6dWAI7GRRYb1Tl1eNwKwW3CfdnN9WlMguRQMMTo10lZNvEX3w1r+JIXweC00hO
         /ZAmrFmiCDM/PjeFJM9ECo/6emzs72dakBSFA=
Date: Sat, 30 Oct 2010 18:50:42 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: scm: fix information leak to userland
Message-ID: <20101030145042.GB25135@albatros>
References: <1288448796-6147-1-git-send-email-segooon@gmail.com>
 <1288449205.2680.968.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288449205.2680.968.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 16:33 +0200, Eric Dumazet wrote:
> Le samedi 30 octobre 2010 à 18:26 +0400, Vasiliy Kulikov a écrit :
> > Structure cmsghdr is copied to userland with padding bytes
> > unitialized on architectures where __kernel_size_t is unsigned long.
> > It leads to leaking of contents of kernel stack memory.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  Compile tested.
> > 
> >  net/core/scm.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/core/scm.c b/net/core/scm.c
> > index 413cab8..a4a9b70 100644
> > --- a/net/core/scm.c
> > +++ b/net/core/scm.c
> > @@ -233,6 +233,7 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
> >  		msg->msg_flags |= MSG_CTRUNC;
> >  		cmlen = msg->msg_controllen;
> >  	}
> > +	memset(&cmhdr, 0, sizeof(cmhdr));
> >  	cmhdr.cmsg_level = level;
> >  	cmhdr.cmsg_type = type;
> >  	cmhdr.cmsg_len = cmlen;
> 
> 
> ???
> 
> struct cmsghdr {
>         __kernel_size_t cmsg_len;       /* data byte count, including hdr */
>         int             cmsg_level;     /* originating protocol */
>         int             cmsg_type;      /* protocol-specific type */
> };
> 
> Could you explain where are the padding bytes ?

Ah, sorry, nowhere :)  int is stored quite OK after long.  Please ignore this patch.

Thanks,

-- 
Vasiliy
