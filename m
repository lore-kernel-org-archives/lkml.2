Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443Ab1JGMCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:02:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34636 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759867Ab1JGMCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:02:49 -0400
Date: Fri, 7 Oct 2011 13:01:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Satish Burnwal (sburnwal)" <sburnwal@cisco.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Kernel: low stack detected by irq handler
Message-ID: <20111007130154.6c65fad6@lxorguk.ukuu.org.uk>
In-Reply-To: <3A8C969225424C4D8E6BEE65ED8552DA05BA1C0C@XMB-BGL-41C.cisco.com>
References: <3A8C969225424C4D8E6BEE65ED8552DA05BA1C0C@XMB-BGL-41C.cisco.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Oct 2011 17:11:05 +0530
"Satish Burnwal (sburnwal)" <sburnwal@cisco.com> wrote:

> Hello experts,
> I have recently moved from kernel 2.6.18-128 to 2.6.18-194. I have my
> own kernel module also (click). With the new 2.6.18-194 version of
> kernel, I am getting this error:
> 
> Kernel: low stack detected by irq handler

You are using too much stack basically and the kernel is catching this.
The call trace should let you work out which path through your code is
the problem.

You've got an IRQ in the middle so it may well be its the combination of
too much stack being used by the main code paths and an IRQ at just the
wrong moment causing further high stack usage in the IRQ path that tips
it over the edge.


