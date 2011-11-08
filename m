Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab1KHOJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:09:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37228 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab1KHOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:09:22 -0500
Date: Tue, 8 Nov 2011 14:10:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: karl@iwl.com
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: Re: Kernel (3.0 and later) panic
Message-ID: <20111108141014.2dfd614f@lxorguk.ukuu.org.uk>
In-Reply-To: <4EB83D4A.4010408@iwl.com>
References: <4EB83D4A.4010408@iwl.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Nov 2011 12:19:22 -0800
Karl Auerbach <karl@iwl.com> wrote:

> Versions 3.0 and later of the Linux kernel get a null pointer panic when
> booting on a Soekris Net6501 board.
> 
> The documentation for that board is at:
> 
>   http://soekris.com/media/manuals/net6501_manual.pdf
> 
> (It's an Intel Atom based board.)

And with an EG20T. Yes I see whats going on.

I think its being caused by Tomoya Morinaga's patch to handle EG20T
nicely. If you don't have the EG20T driver in then it tries to fall back
to 8250 but the entries are missing

	.setup = pci_default_setup.


Patch to test will follow in about 2 minutes. Please test and report back.

Alan
