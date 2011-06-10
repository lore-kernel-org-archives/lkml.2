Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1FJQrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:47:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24981 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1FJQrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NH3WAMa8vfDjGinG8ulkrSKATx6E2KpG7aPbZNS2et4w40Tn7pmHmasu1EgSFOZy3/
         NylN1BFn8X8zLHCOmwLQ==
MIME-Version: 1.0
In-Reply-To: <20110610164456.cfcdbd0c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110610164456.cfcdbd0c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 09:47:00 -0700
Message-ID: <BANLkTi=rJVKdhAeAjzfSJ0cMn3GiZpdXusxRL3cPYdJT+Ucneg@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] fix memory.numa_stat file permission
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 12:44 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I'm sorry I missed this bug because I tested as 'root' ...
>
> =
> From 9fe15b548430635d4bbdc2b39e778dbb08e369c9 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Fri, 10 Jun 2011 16:50:39 +0900
> Subject: [PATCH][BUGFIX] memcg: fix memory.numa_stat file permission
>
>
>  commit 406eb0c9ba765eb066406fd5ce9d5e2b169a4d5a adds memory.numa_stat
>  file for memory cgroup. But it's file permission is wrong.
>
> [kamezawa@bluextal linux-2.6]$ ls -l /cgroup/memory/A/memory.numa_stat
> ---------- 1 root root 0 Jun  9 18:36 /cgroup/memory/A/memory.numa_stat
>
> This patch fixes the permission as
>
> [root@bluextal kamezawa]# ls -l /cgroup/memory/A/memory.numa_stat
> -r--r--r-- 1 root root 0 Jun 10 16:49 /cgroup/memory/A/memory.numa_stat
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bd9052a..ce05835 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4640,6 +4640,7 @@ static struct cftype mem_cgroup_files[] = {
>        {
>                .name = "numa_stat",
>                .open = mem_control_numa_stat_open,
> +               .mode = S_IRUGO,
>        },
>  #endif
>  };
> --
> 1.7.4.1
>
>
>

Acked-by: Ying Han <yinghan@google.com>

--Ying
