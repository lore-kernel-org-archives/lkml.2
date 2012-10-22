Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2JVSZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:25:53 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:57411 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab2JVSZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:25:51 -0400
Message-ID: <50858FAC.10509@acm.org>
Date: Mon, 22 Oct 2012 20:25:48 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jay Fenlason <fenlason@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] prevent CVE-2012-2372 rds-ping causes kernel panic
References: <20121022181253.GA13736@redhat.com>
In-Reply-To: <20121022181253.GA13736@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/12 20:12, Jay Fenlason wrote:
> If you use rds-ping of the local IP address of some Infiniband HCAs
> (QLogic, possibly others) the machine will panic with a BUG_ON due to
> an overly restrictive check.  Loosen the restriction a bit
>
> This should have gotten sent a while ago (it was first noticed in
>   https://bugzilla.redhat.com/show_bug.cgi?id=803936
> and patched in kernel-2.6.32-275.el6) but I got confused about its
> embargo status and lost it.
>
> Signed-off-by: Jay Fenlason <fenlason@redhat.com>
>
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
> index e590949..7920c85 100644
> --- a/net/rds/ib_send.c
> +++ b/net/rds/ib_send.c
> @@ -544,7 +544,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
>   	int flow_controlled = 0;
>   	int nr_sig = 0;
>
> -	BUG_ON(off % RDS_FRAG_SIZE);
> +	BUG_ON(!conn->c_loopback && off % RDS_FRAG_SIZE);
>   	BUG_ON(hdr_off != 0 && hdr_off != sizeof(struct rds_header));
>
>   	/* Do not send cong updates to IB loopback */

Hello Jay,

The recommended approach for checking preconditions is to use 
WARN_ON_ONCE(), not BUG_ON(). Linus explained this last month in a 
message posted on the LKML (http://lkml.org/lkml/2012/9/27/461).

Bart.

