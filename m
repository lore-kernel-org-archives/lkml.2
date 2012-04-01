Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2DANaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 09:30:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49367 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2DANaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 09:30:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAOS58YMjB4HrNOxWMjm=EKqZNd9QmK+QjSv2EfMbYs9MKk+-tA@mail.gmail.com>
References: <20120329164842.GE28941@google.com> <1333044612.15602.4.camel@joe2Laptop>
 <CAOS58YOWA9U3Esb2535v_iivPaXeFYYS3nWd2KKF1=MsfZ0Piw@mail.gmail.com>
 <1333051616.15602.23.camel@joe2Laptop> <CAOS58YMjB4HrNOxWMjm=EKqZNd9QmK+QjSv2EfMbYs9MKk+-tA@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 1 Apr 2012 15:29:51 +0200
Message-ID: <CAPXgP12nMmNwN6-T-2sCsv++-5qyZNokkZFLRQ5LpuwgmuaBWA@mail.gmail.com>
Subject: Re: [PATCH] percpu: use KERN_CONT in pcpu_dump_alloc_info()
To: Tejun Heo <tj@kernel.org>
Cc: Joe Perches <joe@perches.com>, Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 22:11, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Mar 29, 2012 at 1:06 PM, Joe Perches <joe@perches.com> wrote:
>> It'd be just for avoidance of any other possible
>> interleaving from other threads.
>>
>> It's an __init function so that's not too likely,
>> but if it every happens...
>
> Ah, okay.  Forgot about that.  Yeah, the kernel is single threaded at
> that point, so it shouldn't matter. The code is rather complex so
> something simpler would be nice, I agree.
>
> Another thing is that we seem to have structured logging coming our
> way and maybe userspace can deal with racing continuing printks? Not
> sure how different streams could be distinguished tho. Maybe the
> printing task can be used to group them? Kay, is this something
> structured logging would solve?

The kernel's printk() uses a static scratch buffer of 1024 chars. The
prototype for the printk() with facility and structure support I have,
does a bit better and more reliable 'buffered IO' than the current
one.

If interleaved printk messages are still a problem, we could allocate
a per-cpu scratch buffer and all continuation lines which stay on the
same CPU would share the same buffer before it is committed to the
global log buffer.

Kay
