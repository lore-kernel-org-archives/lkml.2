Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0KMRoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 12:44:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35022 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754268Ab0KMRn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 12:43:58 -0500
Date: Sat, 13 Nov 2010 17:42:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, linux-kernel@vger.kernel.org,
        Lawrence Rust <lvr@softsystem.co.uk>
Subject: Re: [PATCH 11/19] 8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT)
 hang
Message-ID: <20101113174240.2bfb79dd@lxorguk.ukuu.org.uk>
In-Reply-To: <20101113144954.GA29977@suse.de>
References: <20101112213215.GB9294@kroah.com>
	<1289598066-10112-11-git-send-email-gregkh@suse.de>
	<AANLkTi=OrD-icAD7Nv5oDrVBekEFMGRSoApWytWgnDbT@mail.gmail.com>
	<20101113144954.GA29977@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lawrence, any ideas?  If not, I'm going to have to revert this patch
> from the tree.

Peering into the waitqueues like that isn't going to work.

I'd suggest simply keeping a proper count (locked) of the number of
people sitting in TIOCMIWAIT, and probably do it in serial_core (because
the bug doesn't look 8250 specific)

Alan
