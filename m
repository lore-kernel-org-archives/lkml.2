Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2A0Vjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:39:39 -0500
Received: from ozlabs.org ([203.10.76.45]:54733 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab2A0Vjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:39:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: Re: [PATCH] module: avoid call vmalloc if init size is zero
In-Reply-To: <1327648756-22255-1-git-send-email-dmitry.antipov@linaro.org>
References: <1327648756-22255-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 27 Jan 2012 21:51:54 +1030
Message-ID: <8762fxcrvx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012 11:19:16 +0400, Dmitry Antipov <dmitry.antipov@linaro.org> wrote:
> For the architectures with it's own module_alloc(), if module init
> size is zero, avoiding module_alloc_update_bounds() and memset()
> no-op calls also eliminates warn_alloc_failed() zero-size warning
> in __vmalloc_node_range().
> 
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>

Please fix __vmalloc_node_range() instead to return ZERO_SIZE_PTR.
And of course, vfree() to use ZERO_OR_NULL_PTR().

Thanks,
Rusty.
