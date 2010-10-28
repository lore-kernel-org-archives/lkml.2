Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab0J1XfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:35:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268Ab0J1Xe7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VY6Tn9cZjScKNTDpkMysLXN6wa/JUB9epfQaRdgxazEwgrwNlmaQOPpPXm30pDeSvu
         gkvapyRdS2QpmWz82bzw==
MIME-Version: 1.0
In-Reply-To: <4CC146BA.7080009@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<4CC146BA.7080009@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 16:34:56 -0700
Message-ID: <AANLkTikf-1kLStxqi5UjP=vn3pqVBHy0OA7ibeWTkJ5z@mail.gmail.com>
Subject: Re: [PATCH 1/7] cgroups: Shrink struct cgroup_subsys
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 1:09 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> On x86_32, sizeof(struct cgroup_subsys) shrinks from 276 bytes
> to 264.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Maybe use "bool" here?

Paul

> ---
> include/linux/cgroup.h |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index ed4ba11..e23ded6 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -481,14 +481,16 @@ struct cgroup_subsys {
>        void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
>
>        int subsys_id;
> -       int active;
> -       int disabled;
> -       int early_init;
> +
> +       unsigned int active:1;
> +       unsigned int disabled:1;
> +       unsigned int early_init:1;
>        /*
>         * True if this subsys uses ID. ID is not available before cgroup_init()
>         * (not available in early_init time.)
>         */
> -       bool use_id;
> +       unsigned int use_id:1;
> +
>  #define MAX_CGROUP_TYPE_NAMELEN 32
>        const char *name;
>
> --
> 1.7.0.1
>
>
