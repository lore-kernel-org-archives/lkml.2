Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab1FBBOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 21:14:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50005 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab1FBBOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 21:14:30 -0400
Subject: Re: [PATCH 2/2] rtc: Avoid accumulating time drift in
 suspend/resume
From: John Stultz <john.stultz@linaro.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <BANLkTinARof1CUhvRoYC4jQqwAsWOX5PVw@mail.gmail.com>
References: <1306908469-15275-1-git-send-email-john.stultz@linaro.org>
	 <1306908469-15275-3-git-send-email-john.stultz@linaro.org>
	 <BANLkTinARof1CUhvRoYC4jQqwAsWOX5PVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 18:14:23 -0700
Message-ID: <1306977263.11492.32.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 17:54 -0700, Arve Hjønnevåg wrote:
> On Tue, May 31, 2011 at 11:07 PM, John Stultz <john.stultz@linaro.org> wrote:
> > +       /*
> > +        * Since these RTC suspend/resume handlers are not called
> > +        * at the very end of suspend or the start of resume,
> > +        * some run-time may pass on either sides of the sleep time
> > +        * so subtract kernel run-time between rtc_suspend to rtc_resume
> > +        * to keep things accurate.
> > +        */
> > +       sleep_time = timespec_sub(sleep_time,
> > +                       timespec_sub(new_system, old_system));
> 
> What happens if sleep_time is negative? I think this need to be
> clamped to 0 to avoid backwards jumps when you wake up more than once
> without the rtc advancing.

Good thought! Although that will be easier to catch in
timekeeping_inject_sleeptime(), so I might add it there.

Thanks for the review!
-john



