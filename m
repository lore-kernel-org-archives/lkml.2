Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab2FVSzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:55:17 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:54128 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab2FVSzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:55:15 -0400
MIME-Version: 1.0
In-Reply-To: <1340391005-10880-1-git-send-email-vnagarnaik@google.com>
References: <1340391005-10880-1-git-send-email-vnagarnaik@google.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 22 Jun 2012 11:54:43 -0700
Message-ID: <CAL26m8L-x0jW-aW5DtrNEuihp5CnsMw54OvE9BBx4g6Zp3c=dg@mail.gmail.com>
Subject: Re: [PATCH] tracing: Fix crash due to uninitialized new_pages list head
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 11:50 AM, Vaibhav Nagarnaik
<vnagarnaik@google.com> wrote:
> The new_pages list head in the cpu_buffer is not initialized. When
> adding pages to the ring buffer, if the memory allocation fails in
> ring_buffer_resize, the clean up handler tries to free up the allocated
> pages from all the cpu buffers. The panic is caused by referencing the
> uninitialized new_pages list head.
>
> Initializing the new_pages list head in rb_allocate_cpu_buffer fixes
> this.
>
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---

Hi Steven,

I believe this fix should be pushed to 3.5 along with the other patch
I sent earlier:
tracing: Update entries counter when removing pages

These two patches fix issues with the recently added atomic resize patches.


Thanks

Vaibhav Nagarnaik
