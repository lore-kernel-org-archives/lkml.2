Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1CaOvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:51:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37928 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757789Ab1CaOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:51:52 -0400
Date: Thu, 31 Mar 2011 15:52:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] vt: avoid BUG_ON in con_shutdown when con_open returns
 with error
Message-ID: <20110331155222.061f9c9f@lxorguk.ukuu.org.uk>
In-Reply-To: <20110331133725.GA2040@herton-IdeaPad-Y430>
References: <1301524178-7925-1-git-send-email-herton.krzesinski@canonical.com>
	<20110331105811.5d989e86@bob.linux.org.uk>
	<20110331133725.GA2040@herton-IdeaPad-Y430>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I still wonder though if really the BUG_ON is ok, or I still didn't got
> that code right. Even if it returns -ERESTARTSYS we will hit that
> BUG_ON, if vc->port.tty != tty no? Or that is what the BUG_ON is trying
> to catch?

The code is trying to trap a locking error on hangup cases I think.
Although the console code currently handles this via its own different
locking so is a bit of a mess - it wants moving to the tty kref stuff
properly but thats not yet been done.

> While looking I noted a minor thing, in tty_open we don't need to check
> retval again in one place, as !retval is always true, because we return
> earlier (in retval = tty_add_file ...):

Agreed - that change

Acked-by: Alan Cox <alan@linux.intel.com>

