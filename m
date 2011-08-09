Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1HICoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 22:44:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57305 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1HICoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 22:44:01 -0400
Subject: Re: [Patch] Correct assignment of uid to gid in credentials
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1312841316.2576.49.camel@schen9-DESK>
References: <1312841316.2576.49.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 04:43:54 +0200
Message-ID: <1312857834.2531.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 08 août 2011 à 15:08 -0700, Tim Chen a écrit :
> This patch corrects an erroneous assignment of uid to gid in credentials
> update.
> 
> Tim
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 4c1ef02..811b53f 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -192,7 +192,7 @@ int __scm_send(struct socket *sock, struct msghdr
> *msg, struct scm_cookie *p)
>  					goto error;
>  
>  				cred->uid = cred->euid = p->creds.uid;
> -				cred->gid = cred->egid = p->creds.uid;
> +				cred->gid = cred->egid = p->creds.gid;
>  				put_cred(p->cred);
>  				p->cred = cred;
>  			}
> 
> 

Good catch Tim.

BTW your patch is a bit flawed : one wrapped line and "---" marker
missing.

Could you add in Changelog bug came from commit 257b5358b32f17
(scm: Capture the full credentials of the scm sender) to ease stable
teams work ?
(linux-2.6.36 was the first kernel to include this commit)



