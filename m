Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab2CAMgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:36:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:34755 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2CAMgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:36:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="113443733"
Date: Thu, 1 Mar 2012 14:35:42 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: marcel@holtmann.org, padovan@profusion.mobi, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: Resend: [PATCH] Bluetooth: Fix Endian Bug.
Message-ID: <20120301123540.GE25627@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	santosh nayak <santoshprasadnayak@gmail.com>, marcel@holtmann.org,
	padovan@profusion.mobi, davem@davemloft.net,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1330599561-20392-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330599561-20392-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On Thu, Mar 01, 2012 at 04:29:21PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Fix for endian bug.
> 
> Fix for null dereferenced removed as it is already
> submitted by Andrei.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
>  net/bluetooth/l2cap_sock.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)

We prefer following commit log (this is the example)

<------8<----------------------------------------------------------
|  From: Santosh Nayak <santoshprasadnayak@gmail.com>
|
|  Fix network to host endian conversion for L2CAP chan id.
|
|  Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
|
|  ---
|          * v2 Fix for null dereferenced removed as it is already
|          submitted by Andrei.
|
|    net/bluetooth/l2cap_sock.c |    5 +++--
|    1 files changed, 3 insertions(+), 2 deletions(-)
|
<------8<----------------------------------------------------------


> 
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index 401d942..86d5067 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -82,7 +82,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
>  	}
>  
>  	if (la.l2_cid)
> -		err = l2cap_add_scid(chan, la.l2_cid);
> +		err = l2cap_add_scid(chan, __le16_to_cpu(la.l2_cid));
>  	else
>  		err = l2cap_add_psm(chan, &la.l2_bdaddr, la.l2_psm);
>  
> @@ -123,7 +123,8 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr, int al
>  	if (la.l2_cid && la.l2_psm)
>  		return -EINVAL;
>  
> -	err = l2cap_chan_connect(chan, la.l2_psm, la.l2_cid, &la.l2_bdaddr);
> +	err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
> +				&la.l2_bdaddr);

I live this to Marcel to decide should we reindent our code otherwise this
one looks odd.

Best regards 
Andrei Emeltchenko 

