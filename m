Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab0HTXwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 19:52:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab0HTXwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 19:52:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ZYV91acHR4oBA225dOfhvrWYn0rtF8IDI7KFDQwGm0uvmRbcjddrjbvj6oAiTaL5R
	codoXrXmD+T7Wu055fP7A==
MIME-Version: 1.0
In-Reply-To: <20100820100855.GC8440@localhost>
References: <1282296689-25618-1-git-send-email-mrubin@google.com>
 <1282296689-25618-4-git-send-email-mrubin@google.com> <20100820100855.GC8440@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Fri, 20 Aug 2010 16:51:38 -0700
Message-ID: <AANLkTi=+uNFq5=5gmjfAOhngXqR8RS3dX3E2uEWG33Ot@mail.gmail.com>
Subject: Re: [PATCH 3/4] writeback: nr_dirtied and nr_entered_writeback in /proc/vmstat
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 3:08 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> How about the names nr_dirty_accumulated and nr_writeback_accumulated?
> It seems more consistent, for both the interface and code (see below).
> I'm not really sure though.

Those names don't seem to right to me.
I admit I like "nr_dirtied" and "nr_cleaned" that seems most
understood. These numbers also get very big pretty fast so I don't
think it's hard to infer.

>> In order to track the "cleaned" and "dirtied" counts we added two
>> vm_stat_items.  Per memory node stats have been added also. So we can
>> see per node granularity:
>>
>>    # cat /sys/devices/system/node/node20/writebackstat
>>    Node 20 pages_writeback: 0 times
>>    Node 20 pages_dirtied: 0 times
>
> I'd prefer the name "vmstat" over "writebackstat", and propose to
> migrate items from /proc/zoneinfo over time. zoneinfo is a terrible
> interface for scripting.

I like vmstat also. I can do that.

> Also, are there meaningful usage of per-node writeback stats?

For us yes. We use fake numa nodes to implement cgroup memory isolation.
This allows us to see what the writeback behaviour is like per cgroup.

> The numbers are naturally per-bdi ones instead. But if we plan to
> expose them for each bdi, this patch will need to be implemented
> vastly differently.

Currently I have no plans to do that.

mrubin
