Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2GDOgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:36:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39785 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab2GDOgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:36:45 -0400
Date: Wed, 4 Jul 2012 16:36:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gilad@benyossef.com,
        Len Brown <lenb@kernel.org>, shli@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: CPU isolation question again
Message-ID: <20120704143635.GE28294@somewhere>
References: <CAJRGBZw_my_=Z+Jyb2UBYwW48BpCGYdcuD5mu7erHsX8NSKbDg@mail.gmail.com>
 <20120703112828.GA28294@somewhere>
 <CAJRGBZzn66mpQo+PCQirzqE=Wdm9T7Z01P20FQsHQnTPEd2mqA@mail.gmail.com>
 <20120704132539.GD28294@somewhere>
 <CAJRGBZyBGL97MAjBVBa5cKKsePtDFPiWqN4N-Lcw3V8qw35DTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJRGBZyBGL97MAjBVBa5cKKsePtDFPiWqN4N-Lcw3V8qw35DTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 10:12:43PM +0800, Luming Yu wrote:
> On Wed, Jul 4, 2012 at 9:25 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Wed, Jul 04, 2012 at 08:42:29PM +0800, Luming Yu wrote:
> >> On Tue, Jul 3, 2012 at 7:28 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> > On Wed, Jun 27, 2012 at 09:22:09PM +0800, Luming Yu wrote:
> >> >> Hi there,
> >> >>
> >> >> I noticed some discussion about CPU isolation which points me to the
> >> >> patch set (https://lkml.org/lkml/2011/8/15/245). I'm currently
> >> >> preparing a RFC-patch-set to automatically pick up a few suitable CPUs
> >> >> to isolate then kick them out of service for a while. We need to
> >> >> balance between  thermal & power management And overall system
> >> >> performance during this operation as much as possible. So
> >> >> software-cpu-online-offline interface could not be a good option to
> >> >> me. But to make sure I'm not blindly running on a dead-end path, I'd
> >> >> check with experts here to ensure it makes some sense to isolate CPUs
> >> >> to this level, and the idea also makes some sense, and the most
> >> >> important is it's not implemented yet.
> >> >
> >> > I don't understand what you are trying to do and how exactly. How do you
> >> > plan to do this isolation and how do you want to balance between thermal
> >> > and power?
> >>
> >> My question could be wrong as the question arose several weeks ago
> >> when I came across
> >>  drivers/acpi/acpi_paid.c which looks like a real user who need to
> >> request system automatically
> >> pick up a few CPU to get them isolated and deactivated. Later on, I
> >> noticed tglx's cpu hot plug re-work.
> >> I realized we could reuse the interface to do isolation and deactivation work.
> >>
> >> Of cause, to pick up which ones to isolate and deactivate is another problem.
> >>
> >> cc'ed the author and ACPI maintainer of the driver as well as tglx.
> >
> > May be I'm confused because we both have our own definition of isolation.
> > I'm not sure what kind of CPU isolation you're looking for.
> 
> At first, it needs not avaiable to scheduler.  Then, it needs in
> deepest power saving mode.
> At last, it needs available to scheduler again on demand.
> Sounds very like a typical soft offline cpu, but needs to be low light weight.

I see. So indeed the latest developments made in CPU hotplug could make it a solution
for you.
