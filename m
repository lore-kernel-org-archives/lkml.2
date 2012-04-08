Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2DHWQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 18:16:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41112 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab2DHWQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 18:16:17 -0400
Date: Sun, 8 Apr 2012 23:18:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
Message-ID: <20120408231841.42e28867@pyramind.ukuu.org.uk>
In-Reply-To: <4F81D5C4.9000503@openvz.org>
References: <4F80892A.7050104@zytor.com>
	<4F81D5C4.9000503@openvz.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As such, I would like to suggest the following:
> >
> > 1. For 3.5, add this to feature-removal.txt.
> > 2. For 3.6, remove CONFIG_DEVPTS_MULTIPLE_INSTANCES as a configuration
> >     option, and printk a warning if devpts is mounted without the
> >     "newinstance" option.
> > 3. For 3.9 remove the legacy support including support for a ptmx node
> >     outside the devpts filesystem.

Ok I'm putting my tty maintainers hat on at this point because nobody
seems to be listening

I'm NAKking this change, I'm NAKking the feature-removal change.

If you want this to change convince the distributions there is a point in
supporting it. This is the *wrong* forum to force a cornercase feature
onto a bazillion users, and the wrong way to strongarm maintainers of the
relevant user space.

If udev has a problem handling it nicely because of the way the link is
generated then *fix that problem* so udev automatically gets both cases
right. If need be we can add more messages to udev to tell it what is
expected and what devtmpfs should produce.

Alan
