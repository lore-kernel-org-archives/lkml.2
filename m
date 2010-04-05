Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0DEXPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:15:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686Ab0DEXPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:15:30 -0400
Date: Mon, 5 Apr 2010 16:11:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org,
       pv-drivers@vmware.com
Subject: Re: [PATCH] VMware Balloon driver
Message-Id: <20100405161110.6a66bf82.akpm@linux-foundation.org>
In-Reply-To: <9df0ea91-9bff-4038-99f1-fdb80aad7147@default>
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
	<20100405142419.2c9bea3d.akpm@linux-foundation.org>
	<4BBA5E1C.10706@goop.org>
	<20100405151720.8a6ac5e3.akpm@linux-foundation.org>
	<4BBA6383.7070601@redhat.com
 20100405154023.c7e4f877.akpm@linux-foundation.org>
	<9df0ea91-9bff-4038-99f1-fdb80aad7147@default>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Apr 2010 16:03:48 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > > On 04/06/2010 01:17 AM, Andrew Morton wrote:
> > > >> The basic idea of the driver is to allow a guest system to give up
> > > >> memory it isn't using so it can be reused by other virtual
> > machines (or
> > > >> the host itself).
> > > >>
> > > > So...  does this differ in any fundamental way from what
> > hibernation
> > > > does, via shrink_all_memory()?
> > > >
> > >
> > > Just the _all_ bit, and the fact that we need to report the freed
> > page
> > > numbers to the hypervisor.
> > >
> > 
> > So...  why not tweak that, rather than implementing some parallel
> > thing?
> 
> I think Avi was being facetious ("_all_").  Hibernation assumes
> everything in the machine is going to stop for awhile.  Ballooning
> assumes that the machine has lower memory need for awhile, but
> is otherwise fully operational.

shrink_all_memory() doesn't require that processes be stopped.

If the existing code doesn't exactly match virtualisation's
requirements, it can be changed.

>  Think of it as hot-plug memory
> at a page granularity.

hotplug is different because it targets particular physical pages.  For
this requirement any old page will do.  Preferably one which won't be
needed soon, yes?

