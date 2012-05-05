Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2EEKRy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:17:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65319 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2EEKRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:17:52 -0400
Date: Sat, 5 May 2012 12:17:35 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 4/5] timekeeping: Offer an interface to
 manipulate leap seconds.
Message-ID: <20120505101735.GB8294@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <52e139c98370c405288cbbb4ac76c435dc36731f.1335510125.git.richardcochran@gmail.com>
 <4F9B26D3.1030100@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9B26D3.1030100@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 04:08:03PM -0700, John Stultz wrote:
> On 04/27/2012 01:12 AM, Richard Cochran wrote:
> 
> >+#ifdef CONFIG_DELETE_LEAP_SECONDS
> >+	/* Remembers whether to insert or to delete. */
> >+	int insert_leapsecond;
> >+#endif
> 
> I'm not a big fan of this additional config option.  The maintenance
> burden for the extra condition is probably not worth the code size
> trade-off.  Or it needs way more justification.

Out of curiosity, I looked at ntp-4.2.6p5 to see if they really
support deleting leap seconds or not. Even though the code appears to
try and support them, I spotted a few bugs. There is a hard coded
assumption that the TAI offset is increasing.

This is just the reason why I suggest not supporting deletions (or
only conditionally for nit pickers). You can code it up, but it will
be in vain, since the code will never be tested or used in practice.
Code that is never executed is a true mainenance burden by definition.

Richard
