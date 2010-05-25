Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0EYLfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:35:24 -0400
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:42096 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751603Ab0EYLfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:35:22 -0400
X-Greylist: delayed 719 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 07:35:22 EDT
Date: Tue, 25 May 2010 13:23:07 +0200
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>
To: Julia Lawall <julia@diku.dk>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>, dccp@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 22/27] net/dccp: Use memdup_user
Message-ID: <20100525112307.GA5528@gerrit.erg.abdn.ac.uk>
Mail-Followup-To: Gerrit Renker <gerrit@erg.abdn.ac.uk>,
	Julia Lawall <julia@diku.dk>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	"David S. Miller" <davem@davemloft.net>, dccp@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1005221025040.13021@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005221025040.13021@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ERG-MailScanner: Found to be clean
X-ERG-MailScanner-From: gerrit@erg.abdn.ac.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>

| 
| ---
|  net/dccp/proto.c |   11 +++--------
|  1 file changed, 3 insertions(+), 8 deletions(-)
| 
| diff --git a/net/dccp/proto.c b/net/dccp/proto.c
| index b03ecf6..f79bcef 100644
| --- a/net/dccp/proto.c
| +++ b/net/dccp/proto.c
| @@ -473,14 +473,9 @@ static int dccp_setsockopt_ccid(struct sock *sk, int type,
|  	if (optlen < 1 || optlen > DCCP_FEAT_MAX_SP_VALS)
|  		return -EINVAL;
|  
| -	val = kmalloc(optlen, GFP_KERNEL);
| -	if (val == NULL)
| -		return -ENOMEM;
| -
| -	if (copy_from_user(val, optval, optlen)) {
| -		kfree(val);
| -		return -EFAULT;
| -	}
| +	val = memdup_user(optval, optlen);
| +	if (IS_ERR(val))
| +		return PTR_ERR(val);
|  
|  	lock_sock(sk);
|  	if (type == DCCP_SOCKOPT_TX_CCID || type == DCCP_SOCKOPT_CCID)
