Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0HTIQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:16:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19095 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab0HTIQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:16:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=k2bjK2gyQlolIgBIu9JGm+zKpi2s5R5U24gsN63dlylOjKhWCGUNt4bGj9o5MPRXT
	MOSb2TC3X8KsN8Ln++qZg==
MIME-Version: 1.0
In-Reply-To: <20100820025111.GB5502@localhost>
References: <1282251447-16937-1-git-send-email-mrubin@google.com>
 <1282251447-16937-3-git-send-email-mrubin@google.com> <20100820025111.GB5502@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Fri, 20 Aug 2010 01:16:09 -0700
Message-ID: <AANLkTimKn5BZiCAyr-3XAZuu66Q+ASZgBZ7LDU2Jom1p@mail.gmail.com>
Subject: Re: [PATCH 2/3] writeback: Adding pages_dirtied and pages_entered_writeback
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com, npiggin@suse.de,
        hch@lst.de, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 7:51 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> As Rik said, /proc/sys is not a suitable place.

OK I'm convinced.

> Frankly speaking I've worked on writeback for years and never felt
> the need to add these counters. What I often do is:
>
> $ vmmon -d 1 nr_writeback nr_dirty nr_unstable
>
>     nr_writeback         nr_dirty      nr_unstable
>            68738                0            39568
>            66051                0            42255
>            63406                0            44900
>            60643                0            47663
>            57954                0            50352
>            55264                0            53042
>            52592                0            55715
>            49922                0            58385
> That is what I get when copying /dev/zero to NFS.
>
> I'm very interested in Google's use case for this patch, and why
> the simple /proc/vmstat based vmmon tool is not enough.

So as I understand it from looking at the code vmmon is sampling
nr_writeback, nr_dirty which are exported versions of
global_page_state for NR_FILE_DIRTY and NR_WRITEBACK. These states are
a snapshot of the state of the kernel's pages. Namely how many dpages
ar ein writeback or dirty at the moment vmmon's acquire routine is
called.

vmmon is sampling /proc/vstat and then displaying the difference from
the last time they sampled.  If I am misunderstanding let me know.

This is good for the state of the system but as we compare
application, mm and io performance over long periods of time we are
interested in the surges and fluctuations of the rates of the
producing and consuming of dirty pages also. It can help isolate where
the problem is and also to compare performance between kernels and/or
applications.

mrubin
