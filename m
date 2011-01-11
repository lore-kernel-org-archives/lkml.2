Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1AKRse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:48:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42850 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab1AKRs3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 Jan 2011 12:48:29 -0500
Date: Tue, 11 Jan 2011 12:39:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 1/4] pci, usb: Make usb handoff func all take base
 remapping
Message-ID: <20110111173934.GD14017@dumpdata.com>
References: <4D2AC6BF.3010907@kernel.org>
 <4D2BA8FE.9090204@kernel.org>
 <4D2BAA75.60001@kernel.org>
 <20110111010714.GB32585@kroah.com>
 <4D2BB048.2050509@kernel.org>
 <1294723290.17779.349.camel@pasglop>
 <4D2BF9F3.5080709@kernel.org>
 <1294731467.17779.352.camel@pasglop>
 <AANLkTika_bZxXO3PKek+BHoYqgYGPBPER-H9KJJXjJzn@mail.gmail.com>
 <20110111135655.GA6901@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111135655.GA6901@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 05:56:55AM -0800, Greg KH wrote:
> On Tue, Jan 11, 2011 at 01:21:58AM -0800, Yinghai Lu wrote:
> > On Mon, Jan 10, 2011 at 11:37 PM, Benjamin Herrenschmidt
> > <benh@kernel.crashing.org> wrote:
> > > On Mon, 2011-01-10 at 22:34 -0800, Yinghai Lu wrote:
> > >>
> > >> system_state does not work.
> > >> it only have BOOTING and RUNNING ...
> > >> RUNNING is set in init/main.c::init_post().
> > >> so early_quirk and pci_quirk all with BOOTING stage...
> > >
> > > Or we can make msleep() itself safe...
> > 
> > still think the function pointer is more clean and safe.

You could use the pvops interface. Similar to how it patches
the SMP locking code if it finds to be running under UP.

But that might be way to complex for this issue.
