Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0KHOLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:11:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43933 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752298Ab0KHOLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:11:18 -0500
Date: Mon, 8 Nov 2010 14:09:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Olsa <jolsa@redhat.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: prevent DOS in the flush_to_ldisc
Message-ID: <20101108140938.06b7ee65@lxorguk.ukuu.org.uk>
In-Reply-To: <20101108134840.GA3275@jolsa.brq.redhat.com>
References: <1288163451-3973-1-git-send-email-jolsa@redhat.com>
	<20101108134840.GA3275@jolsa.brq.redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010 14:48:41 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> hi, any feedback?

Don't think I saw this before.

> > The attached patch (based on -next tree) fixes this by adding threshold
> > for processed data. When the threshold is reached, the current work is
> > rescheduled, so another could run.
> > 
> > The threshold is set to the tty buffer maximum size.

That is an n_tty concept really - most other ldiscs simply eat stuff as
it hits them. It's also something we've got some evidence may need to
become a variable, but would still make sense.

Would it be simpler to remember the queue end before the first iteration
and not go past the queue end as it was at the entry to flush_to_ldisc.

Alan
