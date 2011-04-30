Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1D3Pkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:40:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37884 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907Ab1D3Pkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:40:36 -0400
Date: Sat, 30 Apr 2011 16:41:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-ID: <20110430164141.55d0ef0a@lxorguk.ukuu.org.uk>
In-Reply-To: <20110430153452.GA21439@suse.de>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
	<20110429162817.2eb26efb.akpm@linux-foundation.org>
	<20110430112937.06024368@lxorguk.ukuu.org.uk>
	<20110430153452.GA21439@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > A large vmalloc array is very antisocial on a 32bit x86 box. It looks
> > like almost all of it would become sane if there was an array of pointers
> > to raw devices and the devices were initially allocated on need (even if
> > for now only recovered on rmmod)
> 
> In practice, we've never seen a problem with this[1].  Machines that
> want thousands of raw devices have plenty of memory to handle this
> situation.
> 
> I doubt adding the complexity of dynamically allocating the devices
> as-needed is worth it for the very few systems that ever use this
> driver, compounded with the fact that we keep saying that this code
> isn't to be used by "normal" people anyway.

That's no excuse for sloppy code. Making it an array populated on demand
is an improvement for everyone, making it vmalloc hurts every access (in
TLB misses for one as well as vmalloc overhead).

I note two of us immediately made the same observation. Doing it
basically right (array of pointers) is easy. Doing the full works with a
hash for the lookups is a bit harder and that I would agree is overkill.

Alan
