Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab2LBSFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 13:05:55 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49414 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2LBSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 13:05:53 -0500
Date: Sun, 2 Dec 2012 18:10:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Chen Gang <gang.chen@asianux.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] synclink fix ldisc buffer argument
Message-ID: <20121202181057.097012c6@pyramind.ukuu.org.uk>
In-Reply-To: <F6B8A325-7DBF-4623-B16C-CDC5642EFD16@microgate.com>
References: <50B6E751.9000000@asianux.com>
	<20121129051335.GA4375@kroah.com>
	<50B6F967.3050000@asianux.com>
	<20121129183207.GA4688@kroah.com>
	<50B81F76.8020508@asianux.com>
	<50B8DDAC.8070901@microgate.com>
	<50B90D0D.9040401@microgate.com>
	<20121202151332.3b6a6504@pyramind.ukuu.org.uk>
	<F6B8A325-7DBF-4623-B16C-CDC5642EFD16@microgate.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2012 10:11:58 -0600
Paul Fulghum <paulkf@microgate.com> wrote:

> True, in this mode line disciplines other than N_HDLC would not be functional and N_HDLC ignores the flag buffer.
> This change won’t make other line disciplines useful, it will just prevent the case of a mistakenly selected line discipline accessing beyond the end of the (dummy) flag buffer.
> 
> I’m fine with or without the change. It is functional now with a chance to read past then end of a buffer if misconfigured. With the change, it has the same functionality without the ability to read past the end of a buffer if misconfigured.

With the change its feeding crap in the flags buffer, which may matter in
future depending what happens to the other bits.

If this is a real issue far better to just kzalloc a blank flag buffer to
match the mtu.
