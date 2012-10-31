Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934471Ab2JaRpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:45:52 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:36599 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933930Ab2JaRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:45:49 -0400
Date: Wed, 31 Oct 2012 17:45:48 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: steffen.klassert@secunet.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6/9] kernel: padata : use this_cpu_ptr per-cpu helper
In-Reply-To: <50910A10.3090004@gmail.com>
Message-ID: <0000013ab7edd68d-5524bd32-c5a1-4cd8-a467-ca565ee4c854-000000@email.amazonses.com>
References: <50910A10.3090004@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> From: Shan Wei <davidshan@tencent.com>
>
>
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> ---
>  kernel/padata.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 89fe3d1..70dffe8 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -204,7 +204,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
>  		goto out;
>  	}
>
> -	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
> +	queue = this_cpu_ptr(pd->pqueue);
>  	if (queue->cpu_index == next_queue->cpu_index) {

Its simpler to just remove the per_cpu op completely and change the if
statement to

	if (this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index))
{

..


