Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0CUD6p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 23:58:45 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34521 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0CUD6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 23:58:39 -0400
Date: Sat, 20 Mar 2010 20:59:39 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Dan Carpenter <error27@gmail.com>
cc: Yehuda Sadeh <yehuda@hq.newdream.net>, ceph-devel@lists.sourceforge.net,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ceph-devel] [patch] ceph: handle kmalloc() failure
In-Reply-To: <20100320123015.GA29929@bicker>
Message-ID: <Pine.LNX.4.64.1003202059260.15445@cobra.newdream.net>
References: <20100320123015.GA29929@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010, Dan Carpenter wrote:

> Return ERR_PTR(-ENOMEM) if kmalloc() fails.  We handle allocation 
> failures the same way later in the function.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a260010..655b005 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -328,6 +328,8 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>  	struct ceph_mds_session *s;
>  
>  	s = kzalloc(sizeof(*s), GFP_NOFS);
> +	if (!s)
> +		return ERR_PTR(-ENOMEM);
>  	s->s_mdsc = mdsc;
>  	s->s_mds = mds;
>  	s->s_state = CEPH_MDS_SESSION_NEW;

Applied, thanks!
sage

