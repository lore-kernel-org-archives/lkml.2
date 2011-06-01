Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477Ab1FATbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:31:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47272 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757970Ab1FATbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:31:12 -0400
Date: Wed, 1 Jun 2011 20:32:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        greg@kroah.com
Subject: Re: ioremap warning fix for jsm driver.
Message-ID: <20110601203258.01f3249f@lxorguk.ukuu.org.uk>
In-Reply-To: <20110601183841.GJ21345@caffeine.csclub.uwaterloo.ca>
References: <20110601183841.GJ21345@caffeine.csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011 14:38:41 -0400
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> I saw a warning about ioremap from the jsm driver on a system which
> looked like this:
> 
> resource map sanity check conflict: 0xe0200800 0xe02017ff 0xe0200800 0xe0200fff 0000:01:08.0
> 
> Turns out the warning is valid.  The jsm driver has been asking to ioremap
> 0x1000 forever, but in fact only 8 port chips have 0x1000 bytes of memory.
> 4 port chips have 0x800 and 2 port chips have 0x400 according to the
> data sheet.  It makes more sense to map the size of the region rather
> than a hard coded value.  If you happen to have the regiong legitimately
> mapped to a base addres that is not 4K aligned, ioremap complains
> otherwise.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

Acked-by: Alan Cox <alan@linux.intel.com>
