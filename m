Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1DAUKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 16:10:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40427 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753974Ab1DAUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 16:10:20 -0400
Date: Fri, 1 Apr 2011 21:10:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Charles Samuels <charles@cariden.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Queuing of disk writes
Message-ID: <20110401211049.6c183cfc@lxorguk.ukuu.org.uk>
In-Reply-To: <201104011259.53936.charles@cariden.com>
References: <201104011259.53936.charles@cariden.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the kernel's write cache, and then consequently the disk drive's DMA queue. As 
> a result of that, the harddrive can pick the correct order to do these writes, 
> significantly reducing seek times.

Well that depends a lot on the data, if its very scattered and random it
may not help much.

> And yes, I *know* fsync is a poor method to determine if data is actually 
> committed to something non-volatile. :)

fsync/fdatasync should at least make sure it hit the disk. If barriers
are enabled the rest too.

What file system are you using - some of the file systems have serious
limits in this are around fsync and ordering and you may be hitting those.

The ultima answer is probably an SSD of course 8)

Alan
