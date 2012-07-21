Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab2GUWL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 18:11:27 -0400
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:48159 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751255Ab2GUWLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 18:11:25 -0400
MIME-Version: 1.0
In-Reply-To: <50079125.3020007@wpkg.org>
References: <50079125.3020007@wpkg.org>
From: Roland Dreier <roland@purestorage.com>
Date: Sat, 21 Jul 2012 15:11:03 -0700
Message-ID: <CAL1RGDU8TVBkZ4yP=kjwqvGUsrnQcBGpLa_x-7c=Gu54piVwyw@mail.gmail.com>
Subject: Re: 3.5-rc7 - can no longer wake up from suspend to RAM
To: Tomasz Chmielewski <tch@wpkg.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 9:46 PM, Tomasz Chmielewski <tch@wpkg.org> wrote:
> After upgrading to 3.5-rc7, my laptop no longer wakes up reliable from suspend to RAM. 3.4.x worked fine.

FWIW, I've been having similar problems with 3.5-rc7.  With 3.5-rc6 my
laptop resumed fine, but since updating to -rc7, it often seems to just
sit there after opening the lid -- the moon/sleep LED stays on, and the
power LED smoothly cycles on and off, as if it's fast asleep.  Even pressing
the power button doesn't have any effect (until I hold down the power
button long enough to turn off).

I guess I'll start a bisection, but it's slow going because it takes multiple
tries to know for sure if a kernel is bad.

The only commit between rc6 and rc7 that looks like it might be related
is dc332fdf9f373a87b1e2f423b5b004b2a3c37e1a ("ACPI / PM: Leave
Bus Master Arbitration enabled for suspend/resume"), which apparently
fixes some other laptops.  But perhaps I'll try reverting that and see how
it goes.

 - R.
