Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1HKUYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:24:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:47861 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1HKUYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:24:05 -0400
Subject: Re: [PATCH v6 2/2] Output stall data in debugfs
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>
Date: Thu, 11 Aug 2011 22:23:43 +0200
In-Reply-To: <CAAuSN90BtbRaqkde0iKNQJvpa22AeKJLfyjO6NYqc3kdhqHXtg@mail.gmail.com>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
	 <1312999364-21104-2-git-send-email-zakmagnus@chromium.org>
	 <1313091323.8491.30.camel@twins>
	 <CAAuSN90BtbRaqkde0iKNQJvpa22AeKJLfyjO6NYqc3kdhqHXtg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313094223.26866.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 13:10 -0700, Alex Neronskiy wrote:
> 
> Another change is to allow concurrent writers. The readers are
> serialized but the writers are concurrent; isn't that a strange
> design? The way the "main" index is changed also looks problematic. A
> writer will switch the index before anything useful is even known to
> be in the buffer, and then a reader can go ahead and get that lock and
> read something potentially very old and misleading. I don't think
> that's okay. 

Ah, right, yeah, stick another lock in there.. One does worry about the
whole writer concurrency thing though, isn't it likely all cpus will
tickle the thing in quick succession? Putting a global lock in that path
isn't good,.. always think of the poor sod with the 4096 cpu machine.

Also, is all of this really useful? The hardlockup watchdog is useful
when you mess up bad, but other than that I've never found it to be
useful at all.

I mean, we're at the point where a PREEMPT=y kernel has a pretty decent
latency and the PREEMPT_RT kernels live at ~30us. So wth are you
measuring?
