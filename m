Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750836Ab2AOFSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 00:18:23 -0500
Received: from cobra.newdream.net ([66.33.216.30]:43086 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2AOFSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 00:18:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=zUSJxVjPqcXNQN611jyrDjYCp
	1MIbxQ20PUoEhDMgbllY2hkDJB3uBYNNVyBtRMWBDYSDEVMPYFfG995X6nC6JRlj
	KONGWAI/+s5WBKs+O6WYREhmHi8DAXu9+NM41tVrt0JjCKo0oAXNKG/xgmH7G0QS
	HV2/q8nyozvkj7aCA4=
Date: Sat, 14 Jan 2012 21:18:20 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Xi Wang <xi.wang@gmail.com>
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ceph: fix length validation in parse_reply_info()
In-Reply-To: <1326597659-3892-1-git-send-email-xi.wang@gmail.com>
Message-ID: <Pine.LNX.4.64.1201142117210.24825@cobra.newdream.net>
References: <1326597659-3892-1-git-send-email-xi.wang@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012, Xi Wang wrote:
> "len" is read from network and thus needs validation.  Otherwise, given
> a bogus "len" value, p+len could be an out-of-bounds pointer, which is
> used in further parsing.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>

Applied.  Sorry I missed this the first time around!

sage


> ---
>  fs/ceph/mds_client.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 23ab6a3..3cc9b0b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -262,6 +262,7 @@ static int parse_reply_info(struct ceph_msg *msg,
>  	/* trace */
>  	ceph_decode_32_safe(&p, end, len, bad);
>  	if (len > 0) {
> +		ceph_decode_need(&p, end, len, bad);
>  		err = parse_reply_info_trace(&p, p+len, info, features);
>  		if (err < 0)
>  			goto out_bad;
> @@ -270,6 +271,7 @@ static int parse_reply_info(struct ceph_msg *msg,
>  	/* extra */
>  	ceph_decode_32_safe(&p, end, len, bad);
>  	if (len > 0) {
> +		ceph_decode_need(&p, end, len, bad);
>  		err = parse_reply_info_extra(&p, p+len, info, features);
>  		if (err < 0)
>  			goto out_bad;
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
