Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab3AIHtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:49:02 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55174 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3AIHs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:48:59 -0500
Date: Wed, 9 Jan 2013 08:48:38 +0100
From: Michael Olbrich <m.olbrich@pengutronix.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Alessandro Rubini <rubini@gnudd.com>, federico.vaga@gmail.com,
        mchehab@infradead.org, pawel@osciak.com, hans.verkuil@cisco.com,
        giancarlo.asnaghi@st.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, s.nawrocki@samsung.com
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
Message-ID: <20130109074838.GH13335@pengutronix.de>
Mail-Followup-To: Jonathan Corbet <corbet@lwn.net>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Alessandro Rubini <rubini@gnudd.com>, federico.vaga@gmail.com,
	mchehab@infradead.org, pawel@osciak.com, hans.verkuil@cisco.com,
	giancarlo.asnaghi@st.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, s.nawrocki@samsung.com
References: <3892735.vLSnhhCRFi@harkonnen>
 <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
 <1399400.izKZgEHXnP@harkonnen>
 <12929800.xFTBAueAE0@harkonnen>
 <20130106230947.GA17979@mail.gnudd.com>
 <20130107124050.3fc5031b@lwn.net>
 <20130107181500.24c56803@redhat.com>
 <50EBC1C1.3060208@samsung.com>
 <20130108073130.38a8cc3d@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108073130.38a8cc3d@lwn.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:41:28 up 130 days, 16:16, 11 users,  load average: 0.16, 0.09,
 0.09
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mol@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 07:31:30AM -0700, Jonathan Corbet wrote:
> On Tue, 08 Jan 2013 07:50:41 +0100
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > > Couldn't this performance difference be due to the usage of GFP_DMA inside
> > > the VB2 code, like Federico's new patch series is proposing?
> > >
> > > If not, why are there a so large performance penalty?  
> > 
> > Nope, this was caused rather by a very poor CPU access to non-cached (aka
> > 'coherent') memory and the way the video data has been accessed/read 
> > with CPU.
> 
> Exactly.  Uncached memory *hurts*, especially if you're having to touch it
> all with the CPU.

Even worse, on ARMv7 (at least) the cache implements or is necessary for
(I'm not an expert here) unaligned access. I've seen applications crash
on non-cached memory with a bus error because gcc assumes unaligned access
works. And there isn't even a exception handler in the kernel, probably for
the same reason.

Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
