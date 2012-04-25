Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab2DYW2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 18:28:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54682 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab2DYW2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 18:28:24 -0400
Date: Wed, 25 Apr 2012 15:28:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org
Subject: Re: [BUG]memblock: fix overflow of array index
Message-ID: <20120425222819.GF8989@google.com>
References: <CAHnt0GXW-pyOUuBLB1n6qBP4WNGpET9er_HbJ29s5j5DE1xAdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHnt0GXW-pyOUuBLB1n6qBP4WNGpET9er_HbJ29s5j5DE1xAdA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 04:30:19PM +0800, Peter Teoh wrote:
> Fixing the mismatch in signed and unsigned type assignment, which
> potentially can lead to integer overflow bug.
> 
> Thanks.
> 
> Reviewed-by: Minchan Kim <minchan@kernel.org>
> Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

All indexes in memblock are integers.  Changing that particular one to
unsigned int doesn't fix anything.  I think it just makes things more
confusing.  If there ever are cases w/ more then 2G memblocks, we're
going for 64bit not unsigned.

Thanks.

-- 
tejun
