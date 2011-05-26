Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1EZHCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:02:31 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:51351 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1EZHCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:02:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=jUUN2J1DxawYmTKQ/nlZtCL4awebI5mjGS7Ew0P9UN0vFjd0lTaaqOYdn8vKIoXJZA
         nb0aDqRTEw2ae5kqf3TqvqgXxPe6L4Nq+eU1Qw387N2mAReFW+J8O3zRoUoNaNAxgahb
         vJmoanHynDiqOw+2NMwyETksMUvAG0w7KqME0=
MIME-Version: 1.0
In-Reply-To: <201105250850.12179.oneukum@suse.de>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard> <201105250850.12179.oneukum@suse.de>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Thu, 26 May 2011 09:01:49 +0200
Message-ID: <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Oliver Neukum <oneukum@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 8:50 AM, Oliver Neukum <oneukum@suse.de> wrote:
>
> Am Mittwoch, 25. Mai 2011, 02:00:03 schrieb Dave Chinner:
> > Oh, you're talking about application level write ordering.
(...)
> > Besides, having to work out how to handle subtle application write
> > ordering bugs because you changed fsync semantics is simply another
> > reason for not changing behaviour in the first place.
>
> Sure. I'd say changing the behavior is right out. The question is whether
> we want an additional "superlaptop"-mode.

Exactly. 0.5 Watts is a lot of energy on a modern system. And on some
systems with proper link power management in sata and pcie it will be
even higher (~1 Watt I think). Think not only of the work that will be
lost if the system crashes (unlikely), but also of the work that could
never be done because the battery was gone (a certainty).
>
> And even in this case it seems to me that fsync() cannot be reduced to
> a nop because of ordering constraints. But perhaps we should then consider
> exporting an ordering primitive to user space.

That seems to be the big ordering issue. I had always assumed that
user space writes (by the same app to the same file) would be
committed in order. Is that really not the case?

Wouldn't most app programmers assume ordering? Wouldn't that always
possibly be an issue? Or do all the apps that require ordered writes
use fsync. There will surely be some who require ordering but don't
fsync. And without ordering, some apps won't be able to avoid fsync
without data safety issues.

It would seem that even ordering writes by default could not be a data
safety issue. But I guess performance would be affected negatively in
some cases. And behavior shouldn't be changed. So yes, it seems an
ordering primitive would be a good idea.
