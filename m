Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab1FCWIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:08:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48821 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754156Ab1FCWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:08:34 -0400
Date: Fri, 3 Jun 2011 23:10:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russ Gorby <russ.gorby@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com
Subject: Re: [PATCH 5/5] tty: n_gsm: Fixed NULL ptr OOPs in tty_write_room()
Message-ID: <20110603231028.5c267e60@lxorguk.ukuu.org.uk>
In-Reply-To: <1307127821-21665-6-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
	<1307127821-21665-6-git-send-email-russ.gorby@intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Jun 2011 12:03:41 -0700
Russ Gorby <russ.gorby@intel.com> wrote:

> We saw a case where gsmld_output was called after the MUX
> was shutdown. In this case gsm->tty was null so tty_write_room(NULL)
> was called which resulted in an exception.

This is papering over a problem. It shouldn't be happening. Do you have a
copy of the backtrace of the event and does it occur a lot. If it's a one
off freak event so far then instead add

	if (gsm->tty == NULL) {
		WARN_ON(1);
		return -ENXIO;
	}

so we get dumps from it and the box survives when it occurs. That'll get
us traces to nail it properly. For one your patch is not a valid
ultimate fix because if it can occur what stops gsm->tty changing as it
occurs.

