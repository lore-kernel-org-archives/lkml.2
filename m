Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0IMTfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:35:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60577 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab0IMTfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:35:44 -0400
From: Andi Kleen <andi@firstfloor.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        markus.t.metzger@intel.com
Subject: Re: [PATCH] perf_events: improve DS/BTS/PEBS buffer allocation
References: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com>
Date: Mon, 13 Sep 2010 21:35:39 +0200
In-Reply-To: <4c8e3c0c.12d1d80a.73d9.ffffcf21@mx.google.com> (Stephane
	Eranian's message of "Mon, 13 Sep 2010 16:55:01 +0200")
Message-ID: <877hip4et0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> writes:

> The DS, BTS, and PEBS memory regions were allocated using kzalloc(), i.e.,
> requesting contiguous physical memory. There is no such restriction on
> DS, PEBS and BTS buffers. Using kzalloc() could lead to error in case
> no contiguous physical memory is available. BTS is requesting 64KB,
> thus it can cause issues. PEBS is currently only requesting one page.
> Both PEBS and BTS are static buffers allocated for each CPU at the
> first user. When the last user exists, the buffers are released.

DS supports page tables, but I have some doubts it really 
supports page faults. vmalloc today does page faults. 

I think the change is a good idea, but it will need vmalloc_sync_all()
everywhere.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
