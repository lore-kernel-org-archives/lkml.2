Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab0LVSTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 13:19:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33498 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0LVSTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 13:19:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:reference:user-agent;
        b=eSmpQz69fZtmn8bKrUsZAvjDAaFqCvdoQKihscs9YSh8cCjQ5teDUm5T8xzuT+7bBb
         6z7DyAqfqsK/7Xj1HznBNvTwNRCdEv0kOgZQzJ0D1F50cwUqnO2IJz2YUSkRxQLOFeu5
         oOCFypnQV7K6u9c0xJud47RTVys8b1dc3NUko=
Date: Wed, 22 Dec 2010 20:18:55 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Jochen Voss <voss@seehuhn.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jesse.barnes@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc7
Message-ID: <20101222181855.GA4244@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221233022.GA9188@seehuhn.de>
Reference: <AANLkTi=H7PHrLthxsM6x7bKPVHcn7bmH--7ehwJo1wLB@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 21 Dec 2010 23:30:30 +0000, Jochen Voss wrote:
> On Tue, Dec 21, 2010 at 11:52:17AM -0800, Linus Torvalds wrote:
> > I'm still nervous about some of the regression reports for intel
> > graphics, so please keep testing and reporting. This is the last -rc
> > before xmas (or whatever your holiday may be), so now you all have a
> > few free days when you have nothing better to do than test out an -rc
> > release, right?
>
> For reference, the regression I reported yesterday
> (message id "20101220140615.GA3035@automatix",
> http://www.spinics.net/lists/kernel/msg1126718.html
> on the web) is still present: -rc7 only shows a blank
> screen on my system, -rc7 with 541cc966 reverted works
> without problems.
>

I can confirm the regression: a completely-blank screen right after the
grub prompt.

Printing kernel output using early_printk() all along ('earlyprintk=
serial,keep') shows that the rest of the kernel internally goes on with
its booting process as usual.

Reverting the mentioned 541cc966 commit solves the problem; the bug is
reproducible in both qemu and real hardware.

regards,

-- 
Darwish
http://darwish.07.googlepages.com
