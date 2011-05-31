Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab1EaTr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:47:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22801 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab1EaTrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FhAlbqL+idlABn3skGM6iIBTniuoLw0P9O4gEvQSky4H0iwFznfSZ1fntePRHSnJ/3
         D4wN7NQckVpMg4mixv+w==
MIME-Version: 1.0
In-Reply-To: <f3d616b526e00bd8f01a250b7ce8c5a6e2412768.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com> <f3d616b526e00bd8f01a250b7ce8c5a6e2412768.1306603968.git.joe@perches.com>
From: Paul Menage <menage@google.com>
Date: Tue, 31 May 2011 12:47:27 -0700
Message-ID: <BANLkTikFwfQrvEwHcx5iJe+m8HaGyQ_9BN-0n8C0X5cPjNnOPw@mail.gmail.com>
Subject: Re: [TRIVIAL PATCH next 14/15] mm: Convert vmalloc/memset to vzalloc
To: Joe Perches <joe@perches.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jiri Kosina <trivial@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 10:36 AM, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Paul Menage <menage@google.com>

> ---
>  mm/page_cgroup.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 74ccff6..dbb28fd 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -478,11 +478,10 @@ int swap_cgroup_swapon(int type, unsigned long max_pages)
>        length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
>        array_size = length * sizeof(void *);
>
> -       array = vmalloc(array_size);
> +       array = vzalloc(array_size);
>        if (!array)
>                goto nomem;
>
> -       memset(array, 0, array_size);
>        ctrl = &swap_cgroup_ctrl[type];
>        mutex_lock(&swap_cgroup_mutex);
>        ctrl->length = length;
> --
> 1.7.5.rc3.dirty
>
>
