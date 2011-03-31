Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1CaMLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:11:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40792 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751552Ab1CaMLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:11:20 -0400
Date: Thu, 31 Mar 2011 13:11:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/n_gsm: fix bug in CRC calculation for gsm1 mode
Message-ID: <20110331131144.74a579db@lxorguk.ukuu.org.uk>
In-Reply-To: <1301184300-9158-1-git-send-email-mikhail.kshevetskiy@gmail.com>
References: <1301184300-9158-1-git-send-email-mikhail.kshevetskiy@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Mar 2011 04:05:00 +0400
Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> wrote:

> Problem description:
>   gsm_queue() calculate a CRC for arrived frames. As a last step of
>   CRC calculation it call
> 
>     gsm->fcs = gsm_fcs_add(gsm->fcs, gsm->received_fcs);
> 
>   This work perfectly for the case of GSM0 mode as gsm->received_fcs
>   contain the last piece of data required to generate final CRC.
> 
>   gsm->received_fcs is not used for GSM1 mode. Thus we put an
>   additional byte to CRC calculation. As result we get a wrong CRC
>   and reject incoming frame.
> 
> Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>

(This wants cleaning up better as Mikhael also says but this patch is
clear and unlike a big clean up a better base point for a stable fix and
can be reworked further)
