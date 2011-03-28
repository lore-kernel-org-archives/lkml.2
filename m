Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab1C2AAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:00:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:27641 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398Ab1C2AAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:00:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,258,1299484800"; 
   d="scan'208";a="410051214"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Chinner <david@fromorbit.com>
Cc: John Lepikhin <johnlepikhin@gmail.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: Very aggressive memory reclaim
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>
	<20110328215344.GC3008@dastard>
Date: Mon, 28 Mar 2011 16:58:50 -0700
In-Reply-To: <20110328215344.GC3008@dastard> (Dave Chinner's message of "Tue,
	29 Mar 2011 08:53:44 +1100")
Message-ID: <m2bp0u23wl.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:
>
> First it would be useful to determine why the VM is reclaiming so
> much memory. If it is somewhat predictable when the excessive
> reclaim is going to happen, it might be worth capturing an event

Often it's to get pages of a higher order. Just tracing alloc_pages
should tell you that.

There are a few other cases (like memory failure handling), but they're
more obscure.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
