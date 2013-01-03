Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3ACXll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:41:41 -0500
Received: from smtp131.dfw.emailsrvr.com ([67.192.241.131]:36818 "EHLO
	smtp131.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3ACXlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:41:40 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2013 18:41:40 EST
Message-ID: <50E6158C.3050700@calxeda.com>
Date: Thu, 03 Jan 2013 17:34:36 -0600
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Jon Loeliger <jdl@jdl.com>
Subject: Re: [PATCH] dtc: fdtdump, properly handle multi-string properties
References: <1357252332-6131-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1357252332-6131-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 04:32 PM, Pantelis Antoniou wrote:
> Device tree can store multiple strings in a single property.
> We didn't handle that case properly.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  scripts/dtc/fdtdump.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)

These need to be posted against the upstream dtc sources and to the dtc
maintainer Jon Loeliger.

Rob

> 
> diff --git a/scripts/dtc/fdtdump.c b/scripts/dtc/fdtdump.c
> index 207a46d..d4fa6d7 100644
> --- a/scripts/dtc/fdtdump.c
> +++ b/scripts/dtc/fdtdump.c
> @@ -21,13 +21,23 @@ static void print_data(const char *data, int len)
>  {
>  	int i;
>  	const char *p = data;
> +	const char *s;
>  
>  	/* no data, don't print */
>  	if (len == 0)
>  		return;
>  
>  	if (util_is_printable_string(data, len)) {
> -		printf(" = \"%s\"", (const char *)data);
> +		printf(" = ");
> +
> +		s = data;
> +		do {
> +			printf("\"%s\"", s);
> +			s += strlen(s) + 1;
> +			if (s < data + len)
> +				printf(", ");
> +		} while (s < data + len);
> +
>  	} else if ((len % 4) == 0) {
>  		printf(" = <");
>  		for (i = 0; i < len; i += 4)
> 
