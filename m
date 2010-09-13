Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0IMTtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:49:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:47957 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab0IMTtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:49:39 -0400
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        markus.t.metzger@intel.com
In-Reply-To: <877hip4et0.fsf@basil.nowhere.org>
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
	 <877hip4et0.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 21:49:20 +0200
Message-ID: <1284407360.2275.431.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 21:35 +0200, Andi Kleen wrote:
> Stephane Eranian <eranian@google.com> writes:
> 
> > The DS, BTS, and PEBS memory regions were allocated using kzalloc(), i.e.,
> > requesting contiguous physical memory. There is no such restriction on
> > DS, PEBS and BTS buffers. Using kzalloc() could lead to error in case
> > no contiguous physical memory is available. BTS is requesting 64KB,
> > thus it can cause issues. PEBS is currently only requesting one page.
> > Both PEBS and BTS are static buffers allocated for each CPU at the
> > first user. When the last user exists, the buffers are released.
> 
> DS supports page tables, but I have some doubts it really 
> supports page faults. vmalloc today does page faults. 
> 
> I think the change is a good idea, but it will need vmalloc_sync_all()
> everywhere.

Right, I seem to remember from that last discussion on vmalloc vs NMI
that vmalloc_sync_all() had some issues, or am I totally mis-remembering
that?

But yes, a vmalloc_sync_all() after the vmalloc_node() and this should
indeed work.
