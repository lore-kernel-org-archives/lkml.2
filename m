Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0LaRqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:46:38 -0500
Received: from mail.vyatta.com ([76.74.103.46]:58851 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab0LaRqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:46:37 -0500
Date: Fri, 31 Dec 2010 09:46:34 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] UDPCP Communication Protocol
Message-ID: <20101231094634.5b96e0d1@s6510>
In-Reply-To: <1293787785-3834-1-git-send-email-stefani@seibold.net>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010 10:29:45 +0100
stefani@seibold.net wrote:

> +struct __attribute__ ((packed)) udpcphdr {
> +	struct udphdr udphdr;
> +	__be32 chksum;
> +	__be16 msginfo;
> +	u8 fragamount;
> +	u8 fragnum;
> +	__be16 msgid;
> +	__be16 length;
> +};

Adding (unnecessary) packed attribute will make access slow on
some architectures. For arch that can't do unaligned access, the
compiler ends up doing byte access for each element.
