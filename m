Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965934Ab2EORHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:07:51 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45537 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965909Ab2EORHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:07:49 -0400
Date: Tue, 15 May 2012 18:09:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix boot on Twinhead H12Y
Message-ID: <20120515180938.4a92b611@pyramind.ukuu.org.uk>
In-Reply-To: <1337100727.7050.17.camel@joe2Laptop>
References: <20120515174347.5109.94551.stgit@bluebook>
	<1337100727.7050.17.camel@joe2Laptop>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 09:52:07 -0700
Joe Perches <joe@perches.com> wrote:

> On Tue, 2012-05-15 at 18:44 +0100, Alan Cox wrote:
> > Despite lots of investigation into why this is needed we don't know or have
> > an elegant cure. The only answer found on this laptop is to mark a problem
> > region as used so that Linux doesn't put anything there.
> 
> trivia:
> 
> > diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
> []
> > @@ -519,3 +519,22 @@ static void sb600_disable_hpet_bar(struct pci_dev *dev)
> []
> > +static void __devinit twinhead_reserve_killing_zone(struct pci_dev *dev)
> > +{
> > +        if (dev->subsystem_vendor == 0x14FF && dev->subsystem_device ==
> > +                                        0xA003) {
> 
> Doesn't this look ugly to you?
> Doesn't 
> 
> 	if (dev->subsystem_vendor == 0x14FF &&
> 	    dev->subsystem_device == 0xA003) {
> 
> at least read more easily?

Well I'd further indent the second half so your eyes drop across reading
left to right, but to be honest I'd have put it on one line but for the
80columnists.

If thats the only problem anyone has with it then I'm fine in adding a
tab or two.
