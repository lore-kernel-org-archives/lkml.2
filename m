Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2CBRGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:06:35 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33527 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab2CBRGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:06:33 -0500
Date: Fri, 2 Mar 2012 17:08:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        shemminger@vyatta.com, ying.xue@windriver.com, luiz.dentz@gmail.com,
        rodrigo.moya@collabora.co.uk, javier@collabora.co.uk,
        lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
Message-ID: <20120302170823.7117821b@pyramind.ukuu.org.uk>
In-Reply-To: <4F50F6AA.9050909@collabora.co.uk>
References: <CABBYNZJ-xxQXAx+ecrkVLqmWFaUVqLcQLj0Jxa3McSLnkLJSJw@mail.gmail.com>
	<20120301.170848.432407217191581288.davem@davemloft.net>
	<CABBYNZLwHKd5srzYYzWNL-iaeuH1K31824pY_bjRSbSLkv0QtA@mail.gmail.com>
	<20120302.035509.1994457175982020283.davem@davemloft.net>
	<4F509274.9060302@collabora.co.uk>
	<1330694031.2469.15.camel@edumazet-laptop>
	<4F50F6AA.9050909@collabora.co.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2- The transport layer used by D-bus is not performance sensitive
> basically due:
> 
> a) high number of context switches required to send messages between peer.

This is a user space design issue. The fact dbus wakes up so much
stuff wants fixing at the dbus level.

> b) the D-bus daemon doing the routing and being a bottleneck of the whole.

This is a userspace design issue.

> c) amount of messages copied between kernel space and user space.

This is mostly a userspace design issue and fixing a would fix much of c
because you wouldn't keep sending people crap they didn't need.

You've already got multicast facilities in kernel (if dbus must work by
shouting not state change subscription like saner setups), and you've got
BPF filtering facilities to try and cure some of the wakeups even doing
multicast.

Beyond that I don't see what the kernel can do given its mostly an
architectural problem.

Your model appears to be "since its causing enormous amounts of work we
should do the work faster". The right model would appear to me to be "We
shouldn't cause enormous amounts of work"

Alan
