Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1HSJa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 05:30:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47229 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751896Ab1HSJa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 05:30:56 -0400
Date: Fri, 19 Aug 2011 10:28:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: San Mehat <san@google.com>
Cc: davem@davemloft.net, mst@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        digitaleric@google.com, mikew@google.com, miche@google.com,
        maccarro@google.com
Subject: Re: [RFC 0/0] Introducing a generic socket offload framework
Message-ID: <20110819102835.0a6b2436@lxorguk.ukuu.org.uk>
In-Reply-To: <CAPi7mHqV6Pgk5tSt+fJn_2aEZKZbO=aO78JXgw7MvDaW0musoQ@mail.gmail.com>
References: <20110818220756.5C93E5C80B@san.sea.corp.google.com>
	<20110818235719.50365b0b@lxorguk.ukuu.org.uk>
	<CAPi7mHqV6Pgk5tSt+fJn_2aEZKZbO=aO78JXgw7MvDaW0musoQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have no desire to change the 'genericness' of sockets.. just the
> opposite - i wish to
> introduce the notion that sockets (can be) completely generic (when
> offloaded) as far as
> the guest is concerned.

I suppose my concern is that you don't want to design for a specific
offload device, your offload might change but the view from the
application side should not differ.

> > This guest only view means you can't use the abstraction for local
> > sockets too.
> >
> 
> To be honest, the way we're attempting to integrate is in such a way
> that you *could*
> offload AF_LOCAL sockets...  but that world gets a bit too much like
> the 'Twilight Zone'
> for my current linkings..

Until you want to be able to have a pair of apps talking that may or may
not be on different systems and may or may not be on a vm host at all, at
which point having the same acceleration between them (a null accelerator
so to speak) would avoid having to add extra paths to the apps.

> > And yes there is still the complicated cases such as 'the routing table
> > has changed from vitual host to via siberia now what' but I don't believe
> > your proposal addresses that either.
> 
> Can you be more specific? If you mean solving the 'keeping your tcp connections
> open to non virtual endpoints across a migration (or whatever)' then
> no it doesn't :)

That was my assumption.

