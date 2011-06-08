Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1FHJKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:10:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46410 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752429Ab1FHJKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:10:20 -0400
Date: Wed, 8 Jun 2011 10:04:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guillaume Chazarain <guichaz@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
Message-ID: <20110608100453.6e5cc29d@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTikt1ZZNC1YffT_bRAX6GwjWDk_T3Q@mail.gmail.com>
References: <1306999045.29297.55.camel@pasglop>
	<1307003821.29297.77.camel@pasglop>
	<20110602110727.7343782b@lxorguk.ukuu.org.uk>
	<1307062574.29297.204.camel@pasglop>
	<1307081874.23876.14.camel@pasglop>
	<1307084189.23876.19.camel@pasglop>
	<BANLkTim6VsynZHLagcu9Xo3EjsUz=54dYA@mail.gmail.com>
	<BANLkTikJJfyo-eExZYN4iZUO+RrkgPmX4A@mail.gmail.com>
	<BANLkTi=fX8dwfZ53O7E4HX-RsL6bQ=hqWQ@mail.gmail.com>
	<BANLkTikt1ZZNC1YffT_bRAX6GwjWDk_T3Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd love to get rid of receive_room entirely - and just letting the
> tty line discipline handler say how much it actually received. in
> other words, having receive_buf() just tell us how much it used, and
> not looking at receive_room in the caller is absolutely the right
> thing.

Shouldn't be too hard - the only use of receive_room beyond setting it to
'fire at will' is n_tty.
