Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2A3RnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:43:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49431 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab2A3RnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:43:00 -0500
Date: Mon, 30 Jan 2012 09:42:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
Message-ID: <20120130174256.GF3355@google.com>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org>
 <20120130171558.GB3355@google.com>
 <alpine.DEB.2.00.1201301121330.28693@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201301121330.28693@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:22:14AM -0600, Christoph Lameter wrote:
> On Mon, 30 Jan 2012, Tejun Heo wrote:
> 
> > Percpu pointers are in a different address space and using
> > ZERO_SIZE_PTR directly will trigger sparse address space warning.
> > Also, I'm not entirely sure whether 16 is guaranteed to be unused in
> > percpu address space (maybe it is but I don't think we have anything
> > enforcing that).
> 
> We are already checking for NULL on free. So there is a presumption that
> these numbers are unused.

Yes, we probably don't use 16 as valid dynamic address because static
area would be larger than that.  It's just fuzzier than NULL.  And, as
I wrote in another reply, ZERO_SIZE_PTR simply doesn't contribute
anything.  Maybe we can update the allocator to always not use the
lowest 4k for either static or dynamic and add debug code to
translation macros to check for percpu addresses < 4k, but without
such changes ZERO_SIZE_PTR simply doesn't do anything.

Thanks.

-- 
tejun
