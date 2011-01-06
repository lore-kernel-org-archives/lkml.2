Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1AFNgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:36:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37255 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751522Ab1AFNgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:36:10 -0500
Date: Thu, 6 Jan 2011 13:34:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: starvik@axis.com, Jesper Nilsson <Jesper.Nilsson@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RS485 on Cris: use global value of TIOCSRS485
Message-ID: <20110106133455.2f6175c6@lxorguk.ukuu.org.uk>
In-Reply-To: <4D257C87.4040400@evidence.eu.com>
References: <4D257C87.4040400@evidence.eu.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With this patch, TIOCSRS485 gets the same value across all
> architectures, making maintenance and portability of user-level code
> easier.

I don't see why this is worth doing - no application code should ever
hardcode the value.

> +	case TIOCSRS485DEPR:
> +	{
> +		printk(KERN_DEBUG "The use of this ioctl is deprecated. Use TIOCSRS485 instead\n");
> +		/* Fall through */
> +	}

and letting everyone spew printks is not a good thing.

NAK
