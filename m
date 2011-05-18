Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab1EROfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:35:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52073 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933044Ab1EROfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:35:19 -0400
Date: Wed, 18 May 2011 15:36:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: NULL pointer deref in tty port / uart
Message-ID: <20110518153636.5cdcdd78@lxorguk.ukuu.org.uk>
In-Reply-To: <20110518142631.GB2011@jolsa.brq.redhat.com>
References: <20110517231229.GB1776@nowhere>
	<20110518004420.2b8f5da9@bob.linux.org.uk>
	<20110518142631.GB2011@jolsa.brq.redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> have the same issue.. looks like we should not NULL the port->tty
> if there's blocked open, but not sure what's exactly the logic
> behind "port's block_open and count" ..

A pending open is not a user of the tty as far as the rest of the stack
is concerned. I also don't see why clearing port->tty is causing this
crash because nothing on that path should ever be going via port->tty and
it isn't safe to do so.

> attached patch fixes it for me

But still breaks on hangup where we can't do that.

Where is port->tty getting misused to cause the crash, that is the bit
I'm missing somewhere.
