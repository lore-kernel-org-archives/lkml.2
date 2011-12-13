Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab1LMDcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 22:32:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46129 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1LMDck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 22:32:40 -0500
Date: Tue, 13 Dec 2011 04:32:34 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 1/2] Add clock_gettime_ns syscall
Message-ID: <20111213033233.GB9604@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
 <0c2e36ec36c3ed82bd77a4d4da50ea3efc61aaa9.1323739287.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c2e36ec36c3ed82bd77a4d4da50ea3efc61aaa9.1323739287.git.luto@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 05:26:37PM -0800, Andy Lutomirski wrote:
> On some architectures, clock_gettime is fast enough that converting
> between nanoseconds and struct timespec takes a significant amount of
> time.  Introduce a new syscall that does the same thing but returns the
> answer in nanoseconds.  2^64 nanoseconds since the epoch won't wrap
> around until the year 2554, and by then we can use 128-bit types.

You have here unsigned, but the time_t timespec is signed. To be
consistent which clock_gettime, it would have to be signed, and that
still gives you about 300 years.

OTOH, clearly new and different syscalls can happily be unsigned.

In any case, you should make it clear.

Thanks,
Richard
