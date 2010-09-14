Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab0INErt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:47:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49525 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0INErs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:47:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Sep 2010 13:42:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] devmem: change vread()/vwrite() prototype to return
 success or error code
Message-Id: <20100914134234.b8d861cc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090916014958.722014998@intel.com>
References: <20090916013939.656308742@intel.com>
	<20090916014958.722014998@intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 09:39:40 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Silently ignore all vmalloc area holes in vread()/vwrite(),
> and report success (or error code in future) to the caller.
> 
> The original intention is to fix a vwrite() related bug, where
> it could return 0 which cannot be handled correctly by its caller
> write_kmem(). Then KAMEZAWA recommends to change the prototype
> to make the semantics clear.
> 
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Christoph Lameter <cl@linux-foundation.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Tejun Heo <tj@kernel.org>
> CC: Nick Piggin <npiggin@suse.de>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Okay, maybe it's good to change for now.

I sometimes wonder we should use copy_to/from_user to access vmalloc area...
but we have IO_REMAP. So, maybe vread/vwrite is required one.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks,
-Kame

