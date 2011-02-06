Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1BFXGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:06:08 -0500
Received: from void.printf.net ([89.145.121.20]:47269 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1BFXGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:06:07 -0500
Date: Sun, 6 Feb 2011 23:05:57 +0000
From: Chris Ball <cjb@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Greg KH <gregkh@suse.de>, Marek Belisko <marek.belisko@open-nandra.com>,
        jon.nettleton@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] olpc_dcon: revert strtoul change
Message-ID: <20110206230557.GA24626@void.printf.net>
References: <1296746572-8998-1-git-send-email-marek.belisko@open-nandra.com> <20110204152341.7b869851@debxo> <20110204234443.GB4147@suse.de> <20110206143816.0355ddc5@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110206143816.0355ddc5@queued.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 06, 2011 at 02:38:16PM -0800, Andres Salomon wrote:
> The s/simple_strtoul/strict_strtoul/ from commit e107e6eb added a build
> warning, as well as an oops.  This reverts that change.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/staging/olpc_dcon/olpc_dcon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
> index b19cd34..d6ad5d7 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon.c
> @@ -525,7 +525,7 @@ static int _strtoul(const char *buf, int len, unsigned int *val)
>  {
>  
>  	char *endp;
> -	unsigned int output = strict_strtoul(buf, &endp, 0);
> +	unsigned int output = simple_strtoul(buf, &endp, 0);
>  	int size = endp - buf;
>  
>  	if (*endp && isspace(*endp))

Yes, different prototypes:

  unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base)
vs.
  int strict_strtoul(const char *cp, unsigned int base, unsigned long *res)

So, you'd need something like:

unsigned int output;
int ret = strict_strtoul(buf, 0, &output);
if (ret < 0)
	return ret;

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
