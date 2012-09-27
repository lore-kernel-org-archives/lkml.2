Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2I0JJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:09:05 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35062 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab2I0JJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:09:01 -0400
X-AuditID: b753bd60-98653ba000002f78-6a-506417a6ed7a
X-AuditID: b753bd60-98653ba000002f78-6a-506417a6ed7a
Message-ID: <5064179E.4090507@hitachi.com>
Date: Thu, 27 Sep 2012 18:08:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] perf probe: print an enum type variable in "enum variable-name"
 format when showing accessible variables
References: <1348713399-4541-1-git-send-email-hyc.lee@gmail.com>
In-Reply-To: <1348713399-4541-1-git-send-email-hyc.lee@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/27 11:36), Hyeoncheol Lee wrote:
> When showing accessible variables, an enum type variable was
>  printed in "variable-name" format. Change this format into
> "enum variable-name".

Right, and even if the enum has a type name, it shows
only "type-name variable-name", this should show
"enum type-name variable-name".

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
> ---
>  tools/perf/util/dwarf-aux.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> index ee51e9b..3e5f543 100644
> --- a/tools/perf/util/dwarf-aux.c
> +++ b/tools/perf/util/dwarf-aux.c
> @@ -804,6 +804,8 @@ int die_get_typename(Dwarf_Die *vr_die, char *buf, int len)
>  			tmp = "union ";
>  		else if (tag == DW_TAG_structure_type)
>  			tmp = "struct ";
> +		else if (tag == DW_TAG_enumeration_type)
> +			tmp = "enum ";
>  		/* Write a base name */
>  		ret = snprintf(buf, len, "%s%s", tmp, dwarf_diename(&type));
>  		return (ret >= len) ? -E2BIG : ret;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


