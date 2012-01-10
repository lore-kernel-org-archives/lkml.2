Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2AJIjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:39:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51796 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2AJIjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:39:11 -0500
Date: Tue, 10 Jan 2012 00:39:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Che-liang Chiou <clchiou@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: serio_raw - cosmetic fixes
Message-ID: <20120110083906.GA32252@core.coreip.homeip.net>
References: <1325847795-30486-1-git-send-email-clchiou@chromium.org>
 <20120109082412.GC4049@core.coreip.homeip.net>
 <CANJuy2KrSaqW2XTm4R1+y+KSRZtaNd1_mXW4pP3sOn-_B+h0sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANJuy2KrSaqW2XTm4R1+y+KSRZtaNd1_mXW4pP3sOn-_B+h0sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 04:24:37PM +0800, Che-liang Chiou wrote:
> On Mon, Jan 9, 2012 at 4:24 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Che-Liang,
> >
> > On Fri, Jan 06, 2012 at 07:03:14PM +0800, Che-Liang Chiou wrote:
> >> Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
> >> ---
> >>  drivers/input/serio/serio_raw.c |    4 +---
> >>  1 files changed, 1 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
> >> index 4d4cd14..a935c38 100644
> >> --- a/drivers/input/serio/serio_raw.c
> >> +++ b/drivers/input/serio/serio_raw.c
> >> @@ -220,7 +220,7 @@ static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
> >>                       goto out;
> >>               }
> >>               written++;
> >> -     };
> >> +     }
> >>
> >
> > I applied this chunk, thanks.
> >
> >>  out:
> >>       mutex_unlock(&serio_raw_mutex);
> >> @@ -231,11 +231,9 @@ static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
> >>  {
> >>       struct serio_raw_client *client = file->private_data;
> >>       struct serio_raw *serio_raw = client->serio_raw;
> >> -     unsigned int mask;
> >>
> >>       poll_wait(file, &serio_raw->wait, wait);
> >>
> >> -     mask = serio_raw->dead ? POLLHUP | POLLERR : POLLOUT | POLLWRNORM;
> >>       if (serio_raw->head != serio_raw->tail)
> >>               return POLLIN | POLLRDNORM;
> >>
> >
> > This however is not quite correct. I will be applying the patch below
> > instead.
> 
> Yeah I was wondering maybe you are going to make use of mask
> somewhere. But still the patch below is quite strange. To my
> understanding the mask is still not used; It is a local variable that
> not does not make any side effect. Do you intend to use that mask on
> any global state or return value?

Right, Milton Miller noticed the same. We should be returning mask,
not 0. I'll fix that up.

Thanks.

-- 
Dmitry
