Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2EUTS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:18:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41336 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2EUTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:18:55 -0400
Date: Mon, 21 May 2012 21:18:44 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V2 4/6] time: introduce leap second functional
 interface
Message-ID: <20120521191844.GC19812@netboy.at.omicron.at>
References: <cover.1337348892.git.richardcochran@gmail.com>
 <eee0b50afdea829c727d6210afb8299a4cf30981.1337348892.git.richardcochran@gmail.com>
 <4FBA82DF.9060009@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBA82DF.9060009@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:01:03AM -0700, John Stultz wrote:
> On 05/18/2012 07:09 AM, Richard Cochran wrote:
> >+
> >+int timekeeping_gettod_status(struct timespec *ts, time_t *offset);
> >+
> >+void timekeeping_delete_leap_second(void);
> >+
> >+void timekeeping_finish_leap_second(void);
> >+
> >+void timekeeping_insert_leap_second(void);
> >+
> >+#endif
> 
> Why not just add these to time.h?

This is a private interface only for ntp.c, not for the whole rest of
the kernel via time.h.

BTW this highlights the very icky incestuous relationship between
ntp.c and timekeeper.c. Probably there should be a comment documenting
the (unspoken) locking sequence for ntp_lock and timekeeper.lock.

Thanks,
Richard
