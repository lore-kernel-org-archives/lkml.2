Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab2IKKZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:25:38 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57640 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab2IKKZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:25:37 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-58-504f119d7bb9
From: Namhyung Kim <namhyung@kernel.org>
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip/perf/core ] perf probe: Allow of casting an array of char to string
References: <CANFS6bbt841hyETtTorA6N6weBg+7viBVxwr8Xk0+RJbWXGjXw@mail.gmail.com>
	<CANFS6bb75e8a_UtyAD9yF73hfXDy0N8tSjDz=a+Vna=Y8ORMHg@mail.gmail.com>
Date: Tue, 11 Sep 2012 19:18:38 +0900
In-Reply-To: <CANFS6bb75e8a_UtyAD9yF73hfXDy0N8tSjDz=a+Vna=Y8ORMHg@mail.gmail.com>
	(Hyeoncheol Lee's message of "Tue, 11 Sep 2012 17:00:54 +0900")
Message-ID: <87a9wwc16p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hyeoncheol,

Please CC the perf maintainers - at least Arnaldo for perf tools - next time.

Thanks,
Namhyung


On Tue, 11 Sep 2012 17:00:54 +0900, Hyeoncheol Lee wrote:
> Before casting a type of a variable to string,
> convert_variable_type() confirms that the type is a pointer or
> an array. then if it is a pointer to char, it is casted to string.
> but in case of an array of char, it isn't
>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: H.C. Lee <hyc.lee@gmail.com>
> ---
>  tools/perf/util/probe-finder.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index d448984..94a00de 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -413,12 +413,12 @@ static int convert_variable_type(Dwarf_Die *vr_die,
>                                    dwarf_diename(vr_die), dwarf_diename(&type));
>                         return -EINVAL;
>                 }
> +               if (die_get_real_type(&type, &type) == NULL) {
> +                       pr_warning("Failed to get a type"
> +                                  " information.\n");
> +                       return -ENOENT;
> +               }
>                 if (ret == DW_TAG_pointer_type) {
> -                       if (die_get_real_type(&type, &type) == NULL) {
> -                               pr_warning("Failed to get a type"
> -                                          " information.\n");
> -                               return -ENOENT;
> -                       }
>                         while (*ref_ptr)
>                                 ref_ptr = &(*ref_ptr)->next;
>                         /* Add new reference with offset +0 */
> --
> 1.7.1
