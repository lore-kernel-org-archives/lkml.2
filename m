Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab0E1WZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 18:25:17 -0400
Received: from smtp-out.google.com ([74.125.121.35]:46956 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0E1WZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 18:25:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OzZCgnkbyw/Bshe1tDiCm4OzmxERvWRPh3ogxPJlpazDB9KrbNLuJRUzbFhOsSPNA
	xXfuz4HX4I9jO74KumBIw==
MIME-Version: 1.0
In-Reply-To: <1275059781-9831-1-git-send-email-gthelen@google.com>
References: <1275059781-9831-1-git-send-email-gthelen@google.com>
Date: Fri, 28 May 2010 15:25:08 -0700
Message-ID: <AANLkTino0k-wok9kXLmWTyr40dZKSCnR0Uk41uxAj5k1@mail.gmail.com>
Subject: Re: [PATCH] cgroup: alloc_css_id() increments hierarchy depth
From: Paul Menage <menage@google.com>
To: Greg Thelen <gthelen@google.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 8:16 AM, Greg Thelen <gthelen@google.com> wrote:
>
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: Paul Menage <menage@google.com>

Good catch, thanks.

Paul

> ---
>  kernel/cgroup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 422cb19..3ac6f5b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4598,7 +4598,7 @@ static int alloc_css_id(struct cgroup_subsys *ss, struct cgroup *parent,
>        parent_css = parent->subsys[subsys_id];
>        child_css = child->subsys[subsys_id];
>        parent_id = parent_css->id;
> -       depth = parent_id->depth;
> +       depth = parent_id->depth + 1;
>
>        child_id = get_new_cssid(ss, depth);
>        if (IS_ERR(child_id))
> --
> 1.7.0.1
>
>
