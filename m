Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0HBUsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:48:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57234 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab0HBUsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:48:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=lEMca1NyzPWn1dHkVcngBxPsNez6Veblgtn0ncMR+lQGhMGelJeZXJQgD8i/9hiQHE
         P9YvNMqqQ9LVhbhNo+4rofWLZn1tcwAddN2TAUjIZU+dkLA9gK6VVOawk/Kkegol7sh7
         5tMe23QYeB/JfUxl/bvH69iZ1OKyUw40KLsdI=
From: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM (was: Re: HDD not suspending properly / dead on resume)
Date: Mon, 2 Aug 2010 22:48:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-24-generic; KDE/4.4.5; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@lists.osdl.org
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C384580.2080507@kernel.org> <201007282350.09676.rjw@sisk.pl>
In-Reply-To: <201007282350.09676.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201008022248.45135.stephan.diestelhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 July 2010, 23:50:09 Rafael J. Wysocki wrote:
> On Saturday, July 10, 2010, Tejun Heo wrote:
> > On 07/10/2010 08:50 AM, Stephan Diestelhorst wrote:
> > >> I have a box where this problem is kind of reproducible, but it happens _very_
> > >> rarely.  Also I can't reproduce it on demand running suspend-resume in a tight
> > >> loop.  Are you able to reproduce it more regurarly?
> > > 
> > > For me it is much more reproducible. If I run multiple direct writing
> > > dd-s to the disk in question I trigger it rather reliably (~75% or
> > > higher). See the attached script from an earlier email.
> > > Maybe that helps triggering your case more reliabl, too?
> > 
> That didn't help, but the appended patch fixes the problem for me.

<snip>

Sorry for taking ages. Vacation and catching up after it are to blame,
as is me forgetting to build a proper initrd...

Thanks for the patch! It certainly changes behaviour, however, in a
very strange way for me. With your patch my machine does not suspend
to ram anymore (a simple echo mem > /proc/sys/state blocks), and
nothing happens in dmesg if there is a lot of write I/O while
suspending. (A number of parallel dd's with oflag=direct)

If I stop the I/O, the system eventually goes into suspend to RAM.
However, that takes a while, after the I/O has stopped, and also
from "Preparing system for suspend" log entry until it is actually
done.

Is this intentional? Let me know how I can debug this further!
Ideally I'd like to be able to suspend the machine under I/O load,
too. (E.g. during a compile job.)

Can you reproduce this at your end, too?

Many thanks,
  Stephan
