Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810Ab1DNSFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:05:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51741 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933723Ab1DNSFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:05:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gO2qMZQtGHWKOa5Byh0G0NeMvyuYrNRElG0uTXGx7Oh2UVMNcZ0Re+M11toE6P9wd1
         QVQ8QmOAidmPBVBms42/6EWvOuHGUNRE2+VMOjz6a/gcOmGvxXASRSsj0BwvOVxiPAkH
         Zyfm/qh8j4/j/izxc71EMuorDHUX8a1qK7XNw=
Date: Thu, 14 Apr 2011 20:04:59 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] posix clocks: replace mutex with reader/writer
 semaphore
Message-ID: <20110414180458.GA24534@riccoc20.at.omicron.at>
References: <20110330132421.GA31771@riccoc20.at.omicron.at>
 <alpine.LFD.2.00.1103301541000.22418@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103301541000.22418@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 03:41:40PM +0200, Thomas Gleixner wrote:
> On Wed, 30 Mar 2011, Richard Cochran wrote:
> 
> > A dynamic posix clock is protected from asynchronous removal by a mutex.
> > However, using a mutex has the unwanted effect that a long running clock
> > operation in one process will unnecessarily block other processes.
> > 
> > For example, one process might call read() to get an external time stamp
> > coming in at one pulse per second. A second process calling clock_gettime
> > would have to wait for almost a whole second.
> > 
> > This patch fixes the issue by using a reader/writer semaphore instead of
> > a mutex.
> 
> Yuck. /me wonders why we did not see that during the review :)

Thomas,

I don't see this in -rc3, but I think it should go in.
Can you please take this one?

Thanks,

Richard


