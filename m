Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0IFQav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 12:30:51 -0400
Received: from mail.lixom.net ([70.86.134.90]:51067 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0IFQap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 12:30:45 -0400
Date: Mon, 6 Sep 2010 11:30:44 -0500
From: Olof Johansson <olof@lixom.net>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 4/8] drivers/i2c/busses/i2c-pasemi.c: Fix unsigned
	return type
Message-ID: <20100906163044.GA14188@lixom.net>
References: <1283713226-8429-1-git-send-email-julia@diku.dk> <1283713226-8429-5-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283713226-8429-5-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 09:00:22PM +0200, Julia Lawall wrote:
> The function has an unsigned return type, but returns a negative constant
> to indicate an error condition.  The result of calling the function is
> always stored in a variable of type (signed) int, and thus unsigned can be
> dropped from the return type.
> 
> A sematic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @exists@
> identifier f;
> constant C;
> @@
> 
>  unsigned f(...)
>  { <+...
> *  return -C;
>  ...+> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Olof Johansson <olof@lixom.net>

