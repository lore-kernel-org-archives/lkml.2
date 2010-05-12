Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0ELUHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:07:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57036 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab0ELUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:07:05 -0400
To: Taras Glek <tglek@mozilla.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: How to use perf to log page faults
From: Andi Kleen <andi@halobates.de>
References: <4BEB03B6.6080706@mozilla.com>
Date: Wed, 12 May 2010 22:07:03 +0200
In-Reply-To: <4BEB03B6.6080706@mozilla.com> (Taras Glek's message of "Wed\, 12 May 2010 12\:38\:30 -0700")
Message-ID: <8739xwvq8o.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taras Glek <tglek@mozilla.com> writes:

> Hi,
> From the docs it seems that perf may be useful for logging page
> faults. I tried
> perf record -g -d -f -e page-faults <mycommand>
> but all I got were PERF_RECORD_MMAP events.
>
> I'm using 2.6.32. Ideally I'd like to collect fault addresses and
> userspace stacks that caused them. Isn't this what the page-fault
> event is for?

Some time ago I used systemtap to do this for my pbitmaps
works. This was the old systemtap script.

-Andi

probe vm.pagefault  { 
	if (task_execname(task_current()) == "executable" && address < 0x100000000) { 
		printf("%u\n", address); 
	}

} 



-- 
ak@linux.intel.com -- Speaking for myself only.
