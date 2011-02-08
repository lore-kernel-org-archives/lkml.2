Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1BHUcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:32:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51715 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755207Ab1BHUcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:32:51 -0500
Date: Tue, 8 Feb 2011 20:36:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: james_p_freyensee@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 01/12] export kernel call get_task_comm()
Message-ID: <20110208203602.636575b3@lxorguk.ukuu.org.uk>
In-Reply-To: <20110208202856.GA16696@infradead.org>
References: <james_p_freyensee@linux.intel.com>
	<1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
	<1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
	<20110208193857.GA8839@infradead.org>
	<45773.10.23.16.85.1297194256.squirrel@linux.intel.com>
	<20110208202852.160c080b@lxorguk.ukuu.org.uk>
	<20110208202856.GA16696@infradead.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011 15:28:56 -0500
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Feb 08, 2011 at 08:28:52PM +0000, Alan Cox wrote:
> > On Tue, 8 Feb 2011 11:44:16 -0800 (PST)
> > > > From current you can just dereference current->comm, and access from
> > > > other threads from drivers is a bad idea.
> > 
> > You need to take the locks for it - which get_task_comm encapsulates.
> 
> Not for current->comm, which is the only thing it cares about.

Which is a detail you really don't want to leak out of the proper
abstraction use. I really don't see why you are advocating bad
programming practice - everything else uses the abstraction properly,
this just happens to be the first modular case that wants to behave
properly.
