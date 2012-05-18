Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647Ab2ERKAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:00:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50005 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762586Ab2ERJ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:59:58 -0400
Date: Fri, 18 May 2012 11:02:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 07/16] Closures
Message-ID: <20120518110247.08696cec@pyramind.ukuu.org.uk>
In-Reply-To: <20120518062948.GA21163@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<82f00ebb4ee0404788c5bd7fbfa1fe4969f28ba1.1336619038.git.koverstreet@google.com>
	<20120515224137.GA15386@google.com>
	<20120518062948.GA21163@dhcp-172-18-216-138.mtv.corp.google.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, I can definitely understand your reservations about the code; it's
> strange and foreign and complicated. But having beaten my head against
> the various problems and difficulties inherent in asynchronous
> programming for years - well, having found a way to make it sane to me
> it'd be madness to go back.

I think its more of a different paradigm than complicated. The big
question I'd have to ask is how does it fit with hard real time. That is
a big issue given the gradual merging and getting of "hard" real time
into the kernel proper.

In some ways it's not that strange either. A look at what happens on some
of our kref handling in drivers is very similar but hardcoded.

Is the handling of priority inversion within closures a well understood
and solved problem ?

Alan
