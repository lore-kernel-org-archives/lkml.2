Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1FTKw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:52:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48911 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751768Ab1FTKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:52:28 -0400
Date: Mon, 20 Jun 2011 11:54:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russ Gorby <russ.gorby@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com
Subject: Re: [PATCH 2/2] tty: n_gsm: Added refcount usage to gsm_mux and
 gsm_dlci structs
Message-ID: <20110620115441.48d3544a@lxorguk.ukuu.org.uk>
In-Reply-To: <1308259213-31887-3-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/2] N_GSM: RAW_IP Support : June 16, 2011>
	<1308259213-31887-3-git-send-email-russ.gorby@intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 14:20:13 -0700
Russ Gorby <russ.gorby@intel.com> wrote:

> The gsm_mux is created/destroyed when ldisc is
> opened/closed but clients of the MUX channel devices (gsmttyN)
> may access this structure as long as the TTYs are open.
> For the open, the ldisc open is guaranteed to preceed the TTY open,
> but the close has no such guaranteed ordering. As a result,
> the gsm_mux can be freed in the ldisc close before being accessed
> by one of the TTY clients. This can happen if the ldisc is removed
> while there are open, active MUX channels.
> A similar situation exists for DLCI-0, it is basically a resource
> shared by MUX and DLCI  , and should not be freed while they can
> be accessed
> 
> To avoid this, gsm_mux and dlcis now have a reference counter
> ldisc open takes a reference on the mux and all the dlcis
> gsmtty_open takes a reference on the mux, dlci0 and its specific
> dlci. Dropping the last reference initiates the actual free.
> 
> Signed-off-by: Russ Gorby <russ.gorby@intel.com>

Both Acked-by: Alan Cox <alan@linux.intel.com>

There are some possible bits of tidying up but they can be dealt with in
the future.
