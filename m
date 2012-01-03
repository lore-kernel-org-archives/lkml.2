Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2ACNUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 08:20:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54518 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2ACNUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 08:20:41 -0500
Date: Tue, 3 Jan 2012 13:20:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103132053.44ade1e3@pyramind.ukuu.org.uk>
In-Reply-To: <4F02F244.6040902@fastmail.fm>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F0220F5.30309@fastmail.fm>
	<20120103004220.084d61f3@pyramind.ukuu.org.uk>
	<201201031257.47265.oliver@neukum.org>
	<4F02F244.6040902@fastmail.fm>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That said, I guess there are more complicated / difficult pieces of
> hardware that might not do that. Is that the case here? Can we detect
> that the firmware needs reloading and have the primary driver "yield" to
> the firmware driver?

That doesn't really make any sense in the way USB works.

However if you've got a system to load and pin firmware *on suspend* and
flush it post resume then you don't actually need special 'firmware'
drivers just a slightly fancier lib/firmware that refcounts and handles
load on suspend/delayed flush.

(and probably a sysctl for cache tuning so that typical small firmwares
get cached on bigger boxes anyway for speed)
