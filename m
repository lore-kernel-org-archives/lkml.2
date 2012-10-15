Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2JONdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:33:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37204 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2JONdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:33:03 -0400
Date: Mon, 15 Oct 2012 09:20:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/xenbus: silence GCC warning
Message-ID: <20121015132052.GD4000@phenom.dumpdata.com>
References: <1350295389.1516.27.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350295389.1516.27.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 12:03:09PM +0200, Paul Bolle wrote:
> Compiling xenbus_xs.o triggers this GCC warning:
>     drivers/xen/xenbus/xenbus_xs.c:628:13: warning: function declaration isn’t a prototype [-Wstrict-prototypes]
> 
> Add the obvious and trivial fix.

I already got the fix for this in my tree. Thanks!

> 
> While we're touching this function add some equally obvious and trivial
> whitespace fixes.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Triggered by compiling v3.7-rc1 using (basically) Fedora 17's current
> config. Compile tested only.
> 
> 1) Obligatory reference: https://lwn.net/Articles/487493/ .
> 
>  drivers/xen/xenbus/xenbus_xs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
> index 48220e1..7a2b0da 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -619,13 +619,14 @@ static struct xenbus_watch *find_watch(const char *token)
>  
>  	return NULL;
>  }
> +
>  /*
>   * Certain older XenBus toolstack cannot handle reading values that are
>   * not populated. Some Xen 3.4 installation are incapable of doing this
>   * so if we are running on anything older than 4 do not attempt to read
>   * control/platform-feature-xs_reset_watches.
>   */
> -static bool xen_strict_xenbus_quirk()
> +static bool xen_strict_xenbus_quirk(void)
>  {
>  	uint32_t eax, ebx, ecx, edx, base;
>  
> @@ -635,8 +636,8 @@ static bool xen_strict_xenbus_quirk()
>  	if ((eax >> 16) < 4)
>  		return true;
>  	return false;
> -
>  }
> +
>  static void xs_reset_watches(void)
>  {
>  	int err, supported = 0;
> -- 
> 1.7.11.7
