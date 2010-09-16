Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0IPITS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:19:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56666 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753285Ab0IPITN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:19:13 -0400
Date: Thu, 16 Sep 2010 09:39:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org
Subject: Re: [PATCH] drivers/usb/serial/mos*: prevent reading uninitialized
 stack memory
Message-ID: <20100916093922.197ebe18@lxorguk.ukuu.org.uk>
In-Reply-To: <1284587056.6275.100.camel@dan>
References: <1284587056.6275.100.camel@dan>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 17:44:16 -0400
Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> The TIOCGICOUNT device ioctl in both mos7720.c and mos7840.c allows
> unprivileged users to read uninitialized stack memory, because the
> "reserved" member of the serial_icounter_struct struct declared on the
> stack is not altered or zeroed before being copied back to the user.
> This patch takes care of it.

ACK ... but this is the wrong way to fix these. We'll be squashing new
ones between here and eternity if we just stick memsets in. It wants
making a tty operation off the tty ioctl code so that there is one place
that clears it and copies it to the user.

I'll have a look at what is needed - I don't think very much.

Alan
