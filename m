Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2KBUnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:43:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36821 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab2KBUnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:43:23 -0400
Date: Fri, 2 Nov 2012 20:48:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102204825.7e4bd641@pyramind.ukuu.org.uk>
In-Reply-To: <20121102202131.GE9169@htj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
	<1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
	<20121031212241.GZ2945@htj.dyndns.org>
	<5093DD5E.6030808@redhat.com>
	<20121102153530.483453c7@pyramind.ukuu.org.uk>
	<20121102164828.GA3823@mtj.dyndns.org>
	<20121102172145.184abfe3@pyramind.ukuu.org.uk>
	<20121102173022.GA27843@mtj.dyndns.org>
	<20121102201824.41b2516d@pyramind.ukuu.org.uk>
	<20121102202131.GE9169@htj.dyndns.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012 13:21:31 -0700
Tejun Heo <tj@kernel.org> wrote:

> Hey,
> 
> On Fri, Nov 02, 2012 at 08:18:24PM +0000, Alan Cox wrote:
> > a - there are lots of cases you want to allow only a subset of commands.
> 
> Care to spell them out.  At least the cases Paolo listed should be
> served by what's described.
> 
> > b - if you are using a BPF filter which is the obvious way to do it then
> > the flexibility comes for free without any extra complexity as the kernel
> > provides a generic implementation, and even a JIT for complex cases.
> 
> Yeah, sure, but it's all about what tool to use where and maybe it's
> my ignorance about the problem space but it's difficult for me to
> believe that we need full-blown BPF filter here when this is the only
> activity we've got in a decade.

If you look back through the archive you'll find people have been
spending a good decade bitching about the lack of filter configurability
and trying to get someone else to fix it.

The BPF filter is simpler than just about any other implementation
because the tools exist and are used for lots of other things and it has
an API that is precisely defined as well as kernel calls to run the
filter.

Some reasons for it

- giving people access to parts of disks
- allowing access to specific vendor specific commands on certain
  non-standard CD and DVD drives so they can be used for burning but you
  can't trash them
- giving end users minimal access to things like SMART but only on drives
  where it is safe
- giving a user a SCSI disk or partition to play with but preventing them
  issuing weird ass commands that can disrupt other devices in the fabric
  (like drive to drive transfers, some kinds of resets, management
  commands)
- minimising the ability of a VM to do damage if compromised while
  maximising its raw access to a device



Alan
