Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1JMTHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:07:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35747 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751666Ab1JMTHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:07:16 -0400
Date: Thu, 13 Oct 2011 20:05:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111013200526.74fcc87b@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1110131417070.2026-100000@iolanthe.rowland.org>
References: <CA+O4pC+kRXvGYpnHD7bocuL_t+YWLbChKg8kVAtxmMkd+60+CA@mail.gmail.com>
	<Pine.LNX.4.44L0.1110131417070.2026-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For my part, I don't much mind raising the limit from 16 KB to 32 KB.  
> 48 KB may be unnecessary, especially since one of the devices doesn't 
> even work when the transfer buffer is that large.
> 
> However it's just a work-around, not a real solution to the underlying
> problem (whatever that problem turns out to be).  Part of the reason
> for keeping the limit low is that it shouldn't matter, since people
> ought to be able to use a bunch of small transfers rather than one
> large transfer.  Apparently that justification doesn't work with these
> webcams, although there's no known reason why it shouldn't.
> 
> But I'm not the person in charge of these decisions...

Well if the underlying solution is crap hardware with no work around its
a bit hard to avoid. A more conservative approach would be to put the
'constant' in sysfs where it belongs so it can be adjusted and special
cased.

Alan
