Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1FNOgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:36:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42489 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751156Ab1FNOgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:36:06 -0400
Date: Tue, 14 Jun 2011 15:36:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: markgross@thegnar.org
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] pm loss development
Message-ID: <20110614153630.023eeeef@lxorguk.ukuu.org.uk>
In-Reply-To: <20110614140642.GA14509@gvim.org>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
	<201105180107.58078.rjw@sisk.pl>
	<20110518031203.GA3640@gvim.org>
	<201105182143.13237.rjw@sisk.pl>
	<20110602222111.GA15414@ucw.cz>
	<20110614140642.GA14509@gvim.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I know nothing about journalling file systems or how well they limit the
> critical sections of time where the file system is exposed to corruption
> from sudden power failure.  Its an interesting question though.

A properly written journalling file system has no critical sections. The
only things it relies upon are

- store ordering in the drive working properly
- a single disk block write being atomic

the former is well specified even for ATA devices, the latter is a pretty
safe property of rotating media, although in theory you have a finite
chance of getting a bad sector.

For flash it's a lot lot more complicated but for a flash device claiming
to be ATA compliant you ought to get ATA behaviour.

All that said there is still (as ever) a tiny chance your system may
malfunction. It's all down to probabilities and if your laptop explodes
you need a backup (trust me, I've tested this case).

Alan

