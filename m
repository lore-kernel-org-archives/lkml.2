Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1CVXE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:04:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34717 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754517Ab1CVXEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:04:25 -0400
Date: Tue, 22 Mar 2011 23:04:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Oren Weil <oren.jer.weil@intel.com>, linux-kernel@vger.kernel.org,
        david@woodhou.se
Subject: Re: [PATCH 1/7] char/mei: PCI device and char driver support.
Message-ID: <20110322230437.0a2668e2@lxorguk.ukuu.org.uk>
In-Reply-To: <20110322222259.GA26362@suse.de>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
	<1300791092-14319-2-git-send-email-oren.jer.weil@intel.com>
	<201103221822.43780.arnd@arndb.de>
	<20110322215759.2d982e06@bob.linux.org.uk>
	<20110322222259.GA26362@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011 15:22:59 -0700
Greg KH <gregkh@suse.de> wrote:

> On Tue, Mar 22, 2011 at 09:57:59PM +0000, Alan Cox wrote:
> > > * In the PCI probe function, create a misc character device for
> > >   ". Remove the global
> > >   variables and constants.
> > 
> > The current code is complex and could be a ton simpler *but* don't
> > abuse misc devices when you have one per PCI instance please.
> 
> The code specifically says it only supports one device in the system at
> a time.  Since it can't do any more than that, why wouldn't it be
> correct for a misdevice to be used here?

Arnd was suggesting one device for "every instance you find behind each
device" so that isn't a good idea for a misc device given there will be
lots of them.
