Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2KUMrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:47:52 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34247 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2KUMrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:47:51 -0500
Date: Wed, 21 Nov 2012 12:53:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-kernel@vger.kernel.org, florianschandinat@gmx.de
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
Message-ID: <20121121125310.00625f55@pyramind.ukuu.org.uk>
In-Reply-To: <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
References: <20121116192606.11799.35711.stgit@localhost.localdomain>
	<CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 07:45:45 -0500
Josh Boyer <jwboyer@gmail.com> wrote:

> On Fri, Nov 16, 2012 at 2:27 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > [The fb maintainer appears to be absent at the moment].
> >
> > This is needed to fix a pile of lockdep splats that now show up because console_lock()
> > is being properly audited. Hugh Dickins and Sasha Levin have tested it and both reports
> > all looks good. This is probably not the whole story - the entire fb layer has locking
> > confusion problems that were previously hidden but it seems to get the ones people hit
> > in testing. This hopefully explains a few of the weird fb hangs that have been floating
> > around forever.
> >
> > From: Alan Cox <alan@linux.intel.com>
> >
> > Adjust the console layer to allow a take over call where the caller already
> > holds the locks. Make the fb layer lock in order.
> >
> > This s partly a band aid, the fb layer is terminally confused about the
> > locking rules it uses for its notifiers it seems.
> >
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> Should this eventually get into the stable trees?

Thats a question I'm not sure about at this point. I think the bug is
real but not caught by the lock checker in older trees but I've not
investigated.

Alan
