Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1FSWaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 18:30:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34691 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751482Ab1FSWaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 18:30:19 -0400
Date: Sun, 19 Jun 2011 23:32:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nemo Publius <nemo@self-evident.org>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Does Linux select() violate POSIX?
Message-ID: <20110619233225.17914c60@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTimAxbVWzahU8Ke_Rb8bgiVVrsihRA@mail.gmail.com>
References: <BANLkTik9HzR_oJ7FocQ=o+zNoK22tUTjBg@mail.gmail.com>
	<1308418985.3539.58.camel@edumazet-laptop>
	<BANLkTi=Vis=aZ5vn7E0A2LGVPOcmjd+r-g@mail.gmail.com>
	<20110618193340.53811cbe@lxorguk.ukuu.org.uk>
	<BANLkTi=bvmtkv-o3PROYjmOwkBNCBFGv7w@mail.gmail.com>
	<1308494508.13047.4.camel@thorin>
	<BANLkTimAxbVWzahU8Ke_Rb8bgiVVrsihRA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And I got my answer, which is yes, Linux select() violates POSIX, and
> that decision is deliberate.
> 
> But again, thank you so much for your valuable contribution to the discussion.

It's worth noting that the POSIX semantics are actually unimplementable
for some network protocols anyway particularly on send. TCP is a fine
example. A remote TCP isn't *supposed* to shrink its window but they can
do, and that that point the space select() saw for a send is closed down
again by the remote host.

All sorts of similar issues appear all over the place. There are also
interesting API corner cases such as the behaviour of

	listen()
	select
			connection made
	select returns
			remote closes connection
	accept
			behaviour is not determinate

(and in general POSIX doens't address sockets well)

So for portable code always mix select and poll with non blocking I/O. It
doesn't matter what the specs say, the real world says drive defensively
8)

Alan
