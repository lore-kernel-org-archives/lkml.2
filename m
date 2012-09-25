Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab2IYP0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:26:08 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43579 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2IYP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:26:04 -0400
Date: Tue, 25 Sep 2012 16:30:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: Wrong system clock vs X.509 date specifiers
Message-ID: <20120925163037.20ba3f3c@pyramind.ukuu.org.uk>
In-Reply-To: <21845.1348585794@warthog.procyon.org.uk>
References: <5555.1348531649@warthog.procyon.org.uk>
	<21845.1348585794@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012 16:09:54 +0100
David Howells <dhowells@redhat.com> wrote:

> 
> The X.509 certificate has a pair of times in it that delineate the valid
> period of the cert, and I'm checking that the system clock is within the
> bounds they define before permitting you to use the cert.  I've been setting
> the expiry date to be 100 years in the future - by which time hopefully I
> won't have to worry about it - but occasionally clock skew means a freshly
> built kernel won't boot because the machine trying to boot doesn't think that
> the start time has been reached yet.
> 
> Do we actually want to do this, however?  Or should we just ignore the times?
> Or just the start time?

Generate a certificate that is valid from a few minutes before the
wallclock time. It's a certificate policy question not a kernel hackery
one.

Be careful moving your system clock on 100 years and testing - ext4 gets
some timestamps wrong after 2038.

Alan


