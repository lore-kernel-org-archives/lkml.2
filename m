Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab1CGKb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:31:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55983 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752589Ab1CGKbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:31:55 -0500
Date: Mon, 7 Mar 2011 10:31:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ghozlane Toumi <gtoumi@laposte.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alan Hourihane <alanh@tungstengraphics.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video: add MODULE_DEVICE_TABLE
Message-ID: <20110307103139.53cdaa71@lxorguk.ukuu.org.uk>
In-Reply-To: <1299486373.20702.1.camel@mola>
References: <1299486373.20702.1.camel@mola>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 16:26:13 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> The device table is required to load modules based on modaliases.

Doing this then triggers autoloading which for some of these drivers is
the wrong thing.

> diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
> index 2ab7041..597e80b 100644
> --- a/drivers/video/sstfb.c
> +++ b/drivers/video/sstfb.c
> @@ -1485,6 +1485,7 @@ static const struct pci_device_id sstfb_id_tbl[] = {
>  		.driver_data = ID_VOODOO2, },
>  	{ 0 },
>  };
> +MODULE_DEVICE_TABLE(pci, sstfb_id_tbl);

NAK - as things stand in the frame buffer world you don't want sstfb
autoloading and stealing your main framebuffer away.

