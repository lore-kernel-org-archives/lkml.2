Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2F3NI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 09:08:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45217 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2F3NI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 09:08:28 -0400
Date: Sat, 30 Jun 2012 14:12:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: vincent.sanders@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
Message-ID: <20120630141222.60df95a5@pyramind.ukuu.org.uk>
In-Reply-To: <20120629.165023.1605284574408858612.davem@davemloft.net>
References: <20120629231236.GA28593@mail.collabora.co.uk>
	<20120629.161821.948325645333976311.davem@davemloft.net>
	<20120629234230.GA11480@kyllikki.org>
	<20120629.165023.1605284574408858612.davem@davemloft.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What you really don't get is that packet drops and event losses are
> absolutely fundamental.

The world is full of "receiver reliable" multicast transport providers
which provide ordered defined message delivery properties.

They are reliable in the sense that a message is either queued to the
other ends or is not queued. They are not reliable in the sense of "we
wait forever".

In fact if you look up the stack you'll find a large number of multicast
messaging systems which do reliable transport built on top of IP. In fact
Red Hat provides a high level messaging cluster service that does exactly
this. (as well as dbus which does it on the deskop level) plus a ton of
stuff on top of that (JGroups etc)

Everybody at the application level has been using these 'receiver
reliable'  multicast services for years (Websphere MQ, TIBCO, RTPGM,
OpenPGM, MS-PGM, you name it). There are even accelerators for PGM based
protocols in things like Cisco routers and Solarflare can do much of it
on the card for 10Gbit.

> As long as receivers lack infinite receive queue this will always be
> the case.
> 
> Multicast operates in non-reliable transports only so that one stuck
> or malfunctioning receiver doesn't screw things over for everyone nor
> unduly brudon the sender.

All the world is not IP. Dealing with a malfunctioning receiver is
something dbus already has to deal with. "Unduly burden the sender" is
you talking out of your underwear. The sender is already implementing
this property set - in user space. So there can't be any more burdening,
in fact the point of this is to get rid of excess burdens caused by lack
of kernel support.

This is a latency issue not a throughput one so you can't hide it with
buffers. A few ms shaved off desktop behaviour here and there makes a
massive difference to perceived responsiveness. Less task switches and
daemons means a lot less tasks bouncing around processors which means
less power consumption.

Alan
