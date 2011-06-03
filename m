Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1FCWGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:06:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48794 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756368Ab1FCWGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:06:41 -0400
Date: Fri, 3 Jun 2011 23:08:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russ Gorby <russ.gorby@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com
Subject: Re: [PATCH 3/5] tty: n_gsm: Added refcount usage to gsm_mux and
 gsm_dlci structs
Message-ID: <20110603230836.061d5a78@lxorguk.ukuu.org.uk>
In-Reply-To: <1307127821-21665-4-git-send-email-russ.gorby@intel.com>
References: <[PATCH 0/5] N_GSM patchset : 06/03/2011>
	<1307127821-21665-4-git-send-email-russ.gorby@intel.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To avoid this, gsm_mux and dlcis now have a reference counter
> ldisc open takes a reference on the mux and all the dlcis
> gsmtty_open takes a reference on the mux, dlci0 and its specific
> dlci. Dropping the last reference initiates the actual free.

Definitely the right direction. Only comment really is style related

We usualyl define

struct foo *foo_get(struct foo *)
void foo_put(struct foo *)

helpers/inlines just make it clearer and keep the knowledge of the
function pointer etc in one place

Also when you take a reference this lets you write the more natural
reading

	bar->foo = foo_get(foo);


Alan
