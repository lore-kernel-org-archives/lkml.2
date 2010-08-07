Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882Ab0HGLTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 07:19:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41120 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133Ab0HGLTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 07:19:32 -0400
Date: Sat, 7 Aug 2010 12:33:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tty_io: add an API to get device corresponding to
 tty_struct
Message-ID: <20100807123333.614169f1@lxorguk.ukuu.org.uk>
In-Reply-To: <1281174902-6298-1-git-send-email-dbaryshkov@gmail.com>
References: <20100806165844.GB3364@suse.de>
	<1281174902-6298-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  7 Aug 2010 13:55:02 +0400
Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:

> Some device drivers (mostly tty line disciplines) would like to have way
> to get a struct device instancve corresponding to passed tty_struct. Add
> respective API call.

Most of the kernel simply keeps a parent device pointer in the struct. If
we have a lookup method then we'll simply end up with a struct device in
each tty ldisc struct instead, and it will be harder to clean up later.

I think I'd much rather see this set when the tty is created and always
available. That would also let the whole tty layer use dev_err() and
friends usefully ?

Alan
