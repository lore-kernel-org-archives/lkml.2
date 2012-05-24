Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902Ab2EXSCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:02:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab2EXSCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:02:01 -0400
Date: Thu, 24 May 2012 11:01:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.5-rc0
Message-ID: <20120524180154.GA15036@core.coreip.homeip.net>
References: <20120524083216.GD10562@core.coreip.homeip.net>
 <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:33:49AM -0700, Linus Torvalds wrote:
> On Thu, May 24, 2012 at 1:32 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Linus,
> >
> > to receive updates for the input subsystem. You will get:
> 
> I get an annoying conflict, and the reason I call it annoying is not
> because it's hard to resolve, it's because doing that shows that you
> seem to have preferred using
> 
>    dev_dbg(&input->dev.parent, ...)
> 
> over the much more natural
> 
>    dev_dbg(&input->dev, ...)
> 
> which would seem to make more sense.
> 
> Why? Are the input layer device names so bad that using them for debug
> output is useless? And if so, why *are* they so bad?
> 
> I'm going to take your version over Greg's more straightforward one,
> because I assume Greg did things a bit more mindlessly and I think you
> presumably had a *reason* for your extra (stupid) ".parent" part. But
> I'm unhappy with it, because I suspect the reason you did that implies
> that the input layer does something bad.

A couple of points:

1. A driver should try to use the same device for all its messages and
input devices are not created yet at the time we try to bind USB
interface to a driver. Most (all?) USB probe() methods use interface's
device with dev_xxx() which shows exactly which interface we are dealing
with.

2. Input devices are essentially driver-less (they are class devices) and
therefore do not provide useful information if used in messages as the
format of the message would be:

	input inputX: some message

which does not identify neitehr the driver nor hardware device.  By
using input->dev.parent we get to the USB interface thus getting more
meaningful messages:

	wacom 2-1.2:1.0: some error happened

We had a discussion with Greg about this and he was going to change his
patchset to use USB interfaces in the messages...

Thanks.

-- 
Dmitry
