Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1BMWBs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:01:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38237 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754947Ab1BMWBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:01:42 -0500
Date: Sun, 13 Feb 2011 22:06:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: Brice Goglin <Brice.Goglin@ens-lyon.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: virt_to_page for userspace pointers
Message-ID: <20110213220608.0c4b0cc2@lxorguk.ukuu.org.uk>
In-Reply-To: <4D58537C.3020409@rath.org>
References: <87k4hgn8qa.fsf@inspiron.ap.columbia.edu>
	<878vxuxkfr.fsf@inspiron.ap.columbia.edu>
	<4D4DC2D6.8030905@ens-lyon.org>
	<4D583E17.80606@rath.org>
	<4D5840F6.8030401@ens-lyon.org>
	<4D58537C.3020409@rath.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If you don't lock the page, you have no guarantee that it won't get
> > swapped out or migrated while you look at the physical page.
> 
> That's fine, I know that if the page is there at all then it has been
> locked by a (different) kernel driver. Is there any way to find out what
> I want?

How do you know the other driver isn't in the middle of releasing the
page ? Doing that deep in mm code without locking inversions will be fun.

Alan
