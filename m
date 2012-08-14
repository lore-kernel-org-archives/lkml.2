Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab2HNCbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 22:31:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38415 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2HNCba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 22:31:30 -0400
Date: Tue, 14 Aug 2012 03:31:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Fastabend <john.r.fastabend@intel.com>
Cc: nhorman@tuxdriver.com, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v1 2/2] net: netprio: fd passed in SCM_RIGHTS
 datagram not set correctly
Message-ID: <20120814023128.GG23464@ZenIV.linux.org.uk>
References: <20120814013939.3144.13167.stgit@jf-dev1-dcblab>
 <20120814013944.3144.53854.stgit@jf-dev1-dcblab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814013944.3144.53854.stgit@jf-dev1-dcblab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 06:39:45PM -0700, John Fastabend wrote:
>  		/* Bump the usage count and install the file. */
>  		get_file(fp[i]);
>  		fd_install(new_fd, fp[i]);
> +		sock = sock_from_file(fp[i], &err);
> +		if (sock)
> +			sock->sk->sk_cgrp_prioidx = prioidx;

Better to do that before fd_install() exposes the sucker; it's not
a serious issue, but it's more obviously correct that way.
