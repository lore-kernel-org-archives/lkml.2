Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2ITJiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:38:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33281 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab2ITJh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:37:58 -0400
X-AuditID: b753bd60-94a4dba000002f78-96-505ae3f40c4c
X-AuditID: b753bd60-94a4dba000002f78-96-505ae3f40c4c
Message-ID: <505AE3F3.1040305@hitachi.com>
Date: Thu, 20 Sep 2012 18:37:55 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH] perf probe: Allow of casting an array of char to string
References: <1348117932-786-1-git-send-email-hyc.lee@gmail.com>
In-Reply-To: <1348117932-786-1-git-send-email-hyc.lee@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/20 14:12), Hyeoncheol Lee wrote:
> Before casting a type of a variable to string,
> convert_variable_type() confirms that the type is a pointer or
> an array. if it is a pointer to char, it is casted to string.
> but in case of an array of char, it isn't

Oops, right! I missed the array case. This must be fixed.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
> ---
>  tools/perf/util/probe-finder.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 1daf5c1..be03293 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -413,12 +413,12 @@ static int convert_variable_type(Dwarf_Die *vr_die,
>  				   dwarf_diename(vr_die), dwarf_diename(&type));
>  			return -EINVAL;
>  		}
> +		if (die_get_real_type(&type, &type) == NULL) {
> +			pr_warning("Failed to get a type"
> +				   " information.\n");
> +			return -ENOENT;
> +		}
>  		if (ret == DW_TAG_pointer_type) {
> -			if (die_get_real_type(&type, &type) == NULL) {
> -				pr_warning("Failed to get a type"
> -					   " information.\n");
> -				return -ENOENT;
> -			}
>  			while (*ref_ptr)
>  				ref_ptr = &(*ref_ptr)->next;
>  			/* Add new reference with offset +0 */
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


