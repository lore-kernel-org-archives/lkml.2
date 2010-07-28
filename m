Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0G1QxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:53:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48502 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0G1QxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LdwAqCTjmExwuq4h9NTvhDR6/d+CN6Hi3KjKSNdOPrqzfBaDTN+6nYzmOhSGQzYDPw
         SOBn4EWfcEG7ie5KbHOfJZmOBdbguxvPzytredEUWYvYymXjHP4QBjjquUNGXu8X7IR3
         V+ylqasqKnEF1+pO9Q/XyXsXuUGoyyhqJ9rqY=
MIME-Version: 1.0
In-Reply-To: <1280335203-23305-1-git-send-email-segooon@gmail.com>
References: <1280335203-23305-1-git-send-email-segooon@gmail.com>
Date: Wed, 28 Jul 2010 19:53:06 +0300
X-Google-Sender-Auth: YK1LCYzMJpDXH-XGVY3L3d7MdP4
Message-ID: <AANLkTimhz5D4jthc8__HvHekznWSftXqqDihzjKbW9=P@mail.gmail.com>
Subject: Re: [PATCH 05/10] mm: check kmalloc() return value
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <jbeulich@novell.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 7:40 PM, Kulikov Vasiliy <segooon@gmail.com> wrote:
> kmalloc() may fail, if so return -ENOMEM.
>
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  mm/vmalloc.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index b7e314b..f63684a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2437,8 +2437,11 @@ static int vmalloc_open(struct inode *inode, struct file *file)
>        unsigned int *ptr = NULL;
>        int ret;
>
> -       if (NUMA_BUILD)
> +       if (NUMA_BUILD) {
>                ptr = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
> +               if (ptr == NULL)
> +                       return -ENOMEM;
> +       }
>        ret = seq_open(file, &vmalloc_op);
>        if (!ret) {
>                struct seq_file *m = file->private_data;
> --
> 1.7.0.4
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
