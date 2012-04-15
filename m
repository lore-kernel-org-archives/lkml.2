Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2DOHe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 03:34:56 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:45282 "HELO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752380Ab2DOHez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 03:34:55 -0400
Message-ID: <4F8A7A15.4060908@mellanox.com>
Date: Sun, 15 Apr 2012 10:34:45 +0300
From: Or Gerlitz <ogerlitz@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>, Roland Dreier <roland@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] IB: mlx4: Fix mem leaks in ib_link_query_port()
References: <alpine.LNX.2.00.1204112340360.2137@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204112340360.2137@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 12:43 AM, Jesper Juhl wrote:
> If, in ib_link_query_port(), the call to mlx4_MAD_IFC() fails we will
> currently do 'return err;' which will leak 'in_mad' and 'out_mad' that
> we previously allocated. I believe we should instead do 'goto out;'
> where we'll properly free the memory we previously allocated.

Acked-by: Or Gerlitz <ogerlitz@mellanox.com>

Roland, could you push that?

Or.
