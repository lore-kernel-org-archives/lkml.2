Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2ACAmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:42:37 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47416 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2ACAmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:42:35 -0500
Date: Tue, 3 Jan 2012 00:43:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tty: rework pty count limiting
Message-ID: <20120103004325.0014b646@pyramind.ukuu.org.uk>
In-Reply-To: <4F022DFA.1090105@openvz.org>
References: <20120102172254.11535.2653.stgit@zurg>
	<20120102172301.11535.10338.stgit@zurg>
	<20120102172903.GB19782@suse.de>
	<4F022DFA.1090105@openvz.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That's a userspace api change, why is this going to be allowed?
> 
> open() can return -ENOSPC in case normal fs,
> meanwhile error codes for /dev/ptmx wasn't documented at all:
> there is nothing in manpage pts, pty and ptmx.
> manpage posix_openpt and getpt refers to manpage open(2).
> I can return EIO back, if this is critical.

I prefer the -ENOSPC change - its perfectly within POSIX and while its
vaguely an ABI change I don't believe its one that a single piece of
software actually cares about. So nothing will break (famous last words).

Lets try it and see.

Alan
