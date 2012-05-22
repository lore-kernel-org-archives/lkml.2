Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2EVD6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:58:08 -0400
Received: from cobra.newdream.net ([66.33.216.30]:50122 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2EVD6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:58:07 -0400
Date: Mon, 21 May 2012 20:58:05 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, elder@inktank.com
Subject: Re: linux-next: manual merge of the ceph tree with Linus' tree
In-Reply-To: <20120522114516.2c419f43a0826e9e78f8b3c0@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.1205212056140.6377@cobra.newdream.net>
References: <20120522114516.2c419f43a0826e9e78f8b3c0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Stephen Rothwell wrote:
> Hi Sage,
> 
> Today's linux-next merge of the ceph tree got a conflict in
> net/ceph/messenger.c between commit 95c961747284 ("net: cleanup unsigned
> to unsigned int") from Linus' tree and commit 57dac9d16209 ("ceph:
> messenger: use read_partial() in read_partial_message()") from the ceph
> tree.
> 
> Just context changes. I fixed it up (see below) and can carry the fix as
> necessary.

Thanks, Stephen!  If there's an easier way to carry this in our tree, just 
let me know.

sage


> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc net/ceph/messenger.c
> index 36fa6bf,1a80907..0000000
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@@ -695,12 -698,12 +698,12 @@@ static void prepare_write_banner(struc
>   	set_bit(WRITE_PENDING, &con->state);
>   }
>   
> - static int prepare_write_connect(struct ceph_messenger *msgr,
> - 				 struct ceph_connection *con,
> - 				 int include_banner)
> + static int prepare_write_connect(struct ceph_connection *con)
>   {
>  -	unsigned global_seq = get_global_seq(con->msgr, 0);
>  +	unsigned int global_seq = get_global_seq(con->msgr, 0);
>   	int proto;
> + 	int auth_proto;
> + 	struct ceph_auth_handshake *auth;
>   
>   	switch (con->peer_name.type) {
>   	case CEPH_ENTITY_TYPE_MON:
> @@@ -1627,9 -1663,10 +1663,10 @@@ static int read_partial_message_bio(str
>   static int read_partial_message(struct ceph_connection *con)
>   {
>   	struct ceph_msg *m = con->in_msg;
> + 	int size;
> + 	int end;
>   	int ret;
> - 	int to, left;
>  -	unsigned front_len, middle_len, data_len;
>  +	unsigned int front_len, middle_len, data_len;
>   	bool do_datacrc = !con->msgr->nocrc;
>   	int skip;
>   	u64 seq;
> 
