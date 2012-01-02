Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2ABXx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 18:53:29 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39976 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2ABXxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 18:53:25 -0500
Date: Mon, 2 Jan 2012 23:53:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120102235342.5ebcad41@pyramind.ukuu.org.uk>
In-Reply-To: <4F02165C.1060400@fastmail.fm>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F02165C.1060400@fastmail.fm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jan 2012 20:41:00 +0000
Jack Stone <jwjstone@fastmail.fm> wrote:

> On 02/01/12 16:54, Alan Stern wrote:
> > What Oliver and I have been discussing is delaying the probe call until
> > after resume is finished, when userspace is back up and everything is
> > operating normally again.  It would be more awkward than the current
> > code, but it definitely can be done.
> 
> What about the case where the firmware that needs to be loaded is on the
> USB device that needs the firmware. This can be resolved at boot using
> an initrd but at resume time we don't have that.

There is a very simple answer to such conflicts - don't do it. If you
have firmware you need to reload to get stuff back which might form a
dependancy chain then cache it for the lifetime of the device being in
use. You will never sanely compute that dependancy chain IMHO (although
by all means prove me wrong!) given it might involve things like firmware
over raid over iscsi over nfs over a usb wireless link...

We have the same theoretical problem btw with kernel modules. if they are
on a usb device you need the driver loaded and kept loaded while the
driver is in use - we just happen to do that right anyway so it works
fine.

Alan
