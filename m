Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2EVJXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 05:23:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54715 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2EVJXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 05:23:06 -0400
Date: Tue, 22 May 2012 10:25:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] scsi: usb-storage: hide errors for five devices
Message-ID: <20120522102555.3830d0bd@pyramind.ukuu.org.uk>
In-Reply-To: <1337676514.7898.8.camel@x61.thuisdomein>
References: <1336491453.1933.67.camel@x61.thuisdomein>
	<Pine.LNX.4.44L0.1205081240450.1479-100000@iolanthe.rowland.org>
	<20120515153539.GA25206@kroah.com>
	<1337099344.13455.9.camel@x61.thuisdomein>
	<20120515173613.3c8c2f1f@pyramind.ukuu.org.uk>
	<1337676514.7898.8.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012 10:48:34 +0200
Paul Bolle <pebolle@tiscali.nl> wrote:

> On Tue, 2012-05-15 at 17:36 +0100, Alan Cox wrote:
> > Possibly we should have a hostadapter flag indicating if the cache noise
> > is expected nuisance or not. That way if hardcore SCSI on real cables
> > wants to keeep it then it can still be shut up for USB where its the
> > norm and just irrelevant noise.
> 
> 0) Nobody suggested anything else so maybe I should try to come up with
> a patch that does that. A slight problem is that I'm not at all familiar
> with the SCSI code. And I don't think I own any actual SCSI hardware.

Give it a go.. only one way to learn 8)

> 1) Anyhow: hostadapter flags? Are those perhaps the bitfields starting
> with "active_mode" in "struct Scsi_Host"?

It can probably go in the scsi_host_template. It's going to be per
adapter and fixed. It will still be accessible then via
host->hostt->whatever. That also makes it easier to set correctly.

Alan
