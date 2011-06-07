Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1FGXrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:47:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64439 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1FGXrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p6bfjJQwmYDSwFrIBKFeIzzX/bGzIiU/NuVhxl3ThWib1jBiCzNmdxor43cFvEdLSf
         YG9u5eoKQrgmYKLPf3olBQagKrGNNeQiuDxTvN9IvJjpqwHoN4B+EwQmt8ApiS99XTtu
         66FaFJy6h4MTyNdJccIaj/z+VvvUNSjwToj3g=
Date: Wed, 8 Jun 2011 01:47:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Set __GFP_NORETRY flag for ring buffer allocating
 process
Message-ID: <20110607234713.GD23214@somewhere>
References: <1306519125-19301-1-git-send-email-vnagarnaik@google.com>
 <1307490088-8612-1-git-send-email-vnagarnaik@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307490088-8612-1-git-send-email-vnagarnaik@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 04:41:28PM -0700, Vaibhav Nagarnaik wrote:
> The tracing ring buffer is allocated from kernel memory. While
> allocating a large chunk of memory, OOM might happen which destabilizes
> the system. Thus random processes might get killed during the
> allocation.
> 
> This patch adds __GFP_NORETRY flag to the ring buffer allocation calls
> to make it fail more gracefully if the system will not be able to
> complete the allocation request.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  kernel/trace/ring_buffer.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 2780e60..ec817d5 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1005,7 +1005,8 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
>  	for (i = 0; i < nr_pages; i++) {
>  		struct page *page;
>  		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
> -				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));
> +				    GFP_KERNEL | __GFP_NORETRY,

Please put a comment in the code to explain the reason of this __GFP_NORETRY.
It's pretty hard without the changelog.

Thanks.
