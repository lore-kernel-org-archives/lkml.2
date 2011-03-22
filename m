Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1CVXcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:32:09 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:41779 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752317Ab1CVXcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:32:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=U72LOQc1dpe8XcLPQwYuNHIkCbXK2vtEivKi+S40Abao/YhASkvdGKVXQ5pObxpXKIYKIiEHOMbFBRsoUTCnZTTl/a9S+kRH3xYN1WXcHKE2898smoxrA2rNs0grtC0H;
Date: Tue, 22 Mar 2011 16:32:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Pat Kane <pekane52@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add secdata to unix_streams.
Message-Id: <20110322163204.3bc29a76.rdunlap@xenotime.net>
In-Reply-To: <1300836422-3839-1-git-send-email-pekane52@gmail.com>
References: <y>
	<1300836422-3839-1-git-send-email-pekane52@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011 18:27:02 -0500 Pat Kane wrote:

> The unix_dgram routines add secdata to socket message,
> but the unix_stream routines do not.  We add the two
> missing lines of code.

Please copy netdev@vger.kernel.org on networking patches.

We who?  :)

> Signed-off-by: Pat Kane <pekane52@gmail.com>
> ---
>  net/unix/af_unix.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 1663e1a..3873523 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1642,6 +1642,8 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
>  		max_level = err + 1;
>  		fds_sent = true;
>  
> +                unix_get_secdata(siocb->scm, skb);
> +
>  		err = memcpy_fromiovec(skb_put(skb, size), msg->msg_iov, size);
>  		if (err) {
>  			kfree_skb(skb);
> @@ -1930,6 +1932,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
>  		} else {
>  			/* Copy credentials */
>  			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
> +                        unix_set_secdata(siocb->scm, skb);
>  			check_creds = 1;
>  		}
>  
> -- 

gmail (?) mucked up the indentation tabs -- they are all spaces.  Not good.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
