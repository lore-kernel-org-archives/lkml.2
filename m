Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0LGVsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:48:04 -0500
Received: from xenotime.net ([72.52.115.56]:58978 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753206Ab0LGVsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:48:03 -0500
Message-ID: <50934.71.111.78.224.1291758478.squirrel@xenotime.net>
In-Reply-To: <4CFE5A7B020000780002671D@vpn.id2.novell.com>
References: <4CFE5A7B020000780002671D@vpn.id2.novell.com>
Date: Tue, 7 Dec 2010 13:47:58 -0800 (PST)
Subject: Re: [PATCH] name_to_dev_t() must not call __init code
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, December 7, 2010 7:02 am, Jan Beulich wrote:
> The function can't be __init itself (being called from some sysfs
> handler), and hence none of the functions it call can be either.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

>
> ---
> init/do_mounts.c |    2 +- 1 file changed, 1 insertion(+), 1 deletion(-)
>
>
> --- linux-2.6.37-rc5/init/do_mounts.c
> +++ 2.6.37-rc5-do_mounts-sections/init/do_mounts.c
> @@ -93,7 +93,7 @@ no_match:
> *
> * Returns the matching dev_t on success or 0 on failure.
> */
> -static dev_t __init devt_from_partuuid(char *uuid_str)
> +static dev_t devt_from_partuuid(char *uuid_str)
> {
> dev_t res = 0; struct device *dev = NULL;
>
>
>
> --

-- 
~Randy

