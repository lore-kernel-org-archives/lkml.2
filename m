Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab1BXLuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:50:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46187 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254Ab1BXLuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:50:11 -0500
Date: Thu, 24 Feb 2011 11:52:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: james_p_freyensee@linux.intel.com
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 07/12] n_tracerouter and n_tracesink additions.
Message-ID: <20110224115229.3e482bf2@lxorguk.ukuu.org.uk>
In-Reply-To: <1297971806.3038.30.camel@localhost>
References: <james_p_freyensee@linux.intel.com>
	<1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
	<1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
	<1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
	<1297193697-5417-4-git-send-email-james_p_freyensee@linux.intel.com>
	<1297193697-5417-5-git-send-email-james_p_freyensee@linux.intel.com>
	<1297193697-5417-6-git-send-email-james_p_freyensee@linux.intel.com>
	<1297193697-5417-7-git-send-email-james_p_freyensee@linux.intel.com>
	<1297193697-5417-8-git-send-email-james_p_freyensee@linux.intel.com>
	<20110217192154.GC29448@kroah.com>
	<1297971806.3038.30.camel@localhost>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +#define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
> > > +#define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
> > 
> > Two new ones?  Really?  Alan, no objection from you on this?
> 
> I'll let Alan chime in, but I did have Alan review this code before I
> submitted here.

There isn't really an elegant way of avoiding that. What probably does
want doing for a final merge is to make them more generic. So that
anything can be a source or a sink that meets a basic interface.

Then you'd be able to do

	set ldisc to tracesink
	ioctl (something or other) 		"attach to sink of
						 name 'modem/mipi/p1149.7'

or similar.

That would need a struct of some sort and a register_sink/unregister_sink
method. Ditto for tracerouter. Obviously for now only the current drivers
would support it but the interface is then there for anything else

Alan
