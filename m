Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2JJPnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:43:22 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34167 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2JJPnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:43:19 -0400
Date: Wed, 10 Oct 2012 16:48:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jarkko Huijts <jarkko.huijts@recoresystems.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3.6.1] usb: serial: ftdi_sio: Add missing
 chars_in_buffer function
Message-ID: <20121010164819.01c1a1c0@pyramind.ukuu.org.uk>
In-Reply-To: <20121010130506.GA5876@cora.recoresystems.com>
References: <20121010130506.GA5876@cora.recoresystems.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012 15:05:06 +0200
Jarkko Huijts <jarkko.huijts@recoresystems.com> wrote:

> From: Jarkko Huijts <jarkko.huijts@gmail.com>
> 
> The driver does not wait until the hardware buffer (for data from the PC to the
> UART line) is drained when tcdrain or close is called in an application.
> Solution: Implement a chars_in_buffer function that checks both the software
> and hardware buffer. If the TEMT (TX empty) bit of the line status register
> indicates the hw buffer is not empty, let the function return at least 1. This
> has been verified to work correctly with an FT232RL. The check on the hw buffer
> can not be done for the original SIO device.
> 
> Signed-off-by: Jarkko Huijts <jarkko.huijts@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>
