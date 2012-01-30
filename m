Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab2A3RTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:19:25 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51018 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2A3RTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:19:24 -0500
Date: Mon, 30 Jan 2012 09:19:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
Message-ID: <20120130171919.GC3355@google.com>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org>
 <20120130171558.GB3355@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130171558.GB3355@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 09:15:58AM -0800, Tejun Heo wrote:
> Percpu pointers are in a different address space and using
> ZERO_SIZE_PTR directly will trigger sparse address space warning.
> Also, I'm not entirely sure whether 16 is guaranteed to be unused in
> percpu address space (maybe it is but I don't think we have anything
> enforcing that).

Another thing is that percpu address dereferencing always goes through
rather unintuitive translation and 1. we can't (or rather currently
don't) guarantee that fault will occur for any address 2. even if it
does, the faulting address wouldn't be anything easily
distinguishible.  So, unless the above shortcomings is resolved, I
don't really see much point of using ZERO_SIZE_PTR for percpu
allocator.

Thanks.

-- 
tejun
