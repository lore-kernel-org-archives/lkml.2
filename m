Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab0FSUXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 16:23:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41903 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab0FSUXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:23:50 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org,
       david@fromorbit.com, hch@lst.de, axboe@kernel.dk
Subject: Re: [PATCH 3/3] writeback: tracking subsystems causing writeback
References: <1276907415-504-1-git-send-email-mrubin@google.com>
	<1276907415-504-4-git-send-email-mrubin@google.com>
	<878w6bphc2.fsf@basil.nowhere.org>
	<AANLkTimhsQdLV7UeMppz8mwzQPUfDQbvdNdOCiVnxdKM@mail.gmail.com>
Date: Sat, 19 Jun 2010 22:23:48 +0200
In-Reply-To: <AANLkTimhsQdLV7UeMppz8mwzQPUfDQbvdNdOCiVnxdKM@mail.gmail.com>
	(Michael Rubin's message of "Sat, 19 Jun 2010 10:49:34 -0700")
Message-ID: <87eig2ixez.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Rubin <mrubin@google.com> writes:
>
> I agree. This would put the kernel in a box a bit. Some of them
> (sys_sync, periodic writeback, free_more_memory) I feel are generic
> enough concepts that with some rewording of the labels they could be
> exposed with no issue. "Balance_dirty_pages" is an example where that
> won't work.

Yes some rewording would be good.

> Are there alternatives to this? Maybe tracepoints that are compiled to be on?
> A CONFIG_WRITEBACK_DEBUG that would expose this file?

The classic way is to put it into debugfs which has a appropiate
disclaimer.

(although I fear we're weaning apps that depend on debugfs too
The growing ftrace user space code seems to all depend on debugfs)

> Having this set of info readily available and collected makes
> debugging a lot easier. But I admit I am not sure the best way to
> expose them.

Maybe we just need a simpler writeback path that is not as complicated
to debug. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
