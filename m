Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1JJRbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:31:33 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:10928 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1JJRbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:31:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20115.11246.991917.639835@pilspetsen.it.uu.se>
Date: Mon, 10 Oct 2011 19:31:26 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Greg KH <gregkh@suse.de>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-usb@vger.kernel.org,
        Harro Haan <hrhaan@gmail.com>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] fix ehci alignment error
In-Reply-To: <20111010170042.GB24166@suse.de>
References: <20111010124154.464239811@gmail.com>
	<20111010141402.GA21856@suse.de>
	<yw1xipnwzu7a.fsf@unicorn.mansr.com>
	<20111010170042.GB24166@suse.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH writes:
 > On Mon, Oct 10, 2011 at 05:29:13PM +0100, Måns Rullgård wrote:
 > > Greg KH <gregkh@suse.de> writes:
 > > 
 > > > On Mon, Oct 10, 2011 at 02:38:27PM +0200, Harro Haan wrote:
 > > >> The Kirkwood gave an unaligned memory access error on
 > > >> line 742 of drivers/usb/host/echi-hcd.c:
 > > >> "ehci->last_periodic_enable = ktime_get_real();"
 > > >
 > > > What is "The Kirkwood"?  What size processor is this?
 > > 
 > > It's an ARM926-like CPU from Marvell.
 > 
 > 32 or 64bit?

All ARMs are 32-bit, but some have instructions for loading or
storing 2 x 32 bits at a time, but also require the corresponding
memory address to be 64-bit aligned.
