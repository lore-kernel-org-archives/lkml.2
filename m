Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1GSJDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:03:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49612 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752360Ab1GSJDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:03:13 -0400
Date: Tue, 19 Jul 2011 10:05:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/34] System Firmware Interface
Message-ID: <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk>
In-Reply-To: <m2vcuz3xsz.fsf@firstfloor.org>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com>
	<1310994528-26276-2-git-send-email-prarit@redhat.com>
	<m2vcuz3xsz.fsf@firstfloor.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011 17:43:08 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> Prarit Bhargava <prarit@redhat.com> writes:
> 
> Wow that's a cc list from hell. Cut down to linux-kernel.

Which meant I very nearly missed it so you very nearly missed your answer
8)

> > This patch introduces a general System Firmware interface to the kernel, called
> > sysfw.
> 
> Could you expand somewhat WHY you want this. What is wrong with the
> current code?

See the previous discussions

> As for user space access on x86 "dmidecode"/libdmi works for nearly everyone,
> doesn't it?

"on x86" (and on PC only generally)

There are three core problems

1.	DMI in this sense is basically an x86 PC class device hack
2.	It is obsoleted and at some point it'll vanish even on PC
3.	Every other platform without DMI would benefit from the
	interface being generic

So either we carry on hacking other interfaces (often more informative
ones) into our dmi glue, and trying to keep up the fakery for every case,
or we do what I should have done originally and made the interface a
generic way to query firmware/board information that can be extended
nicely.

We'll still need a spot of fakery for userspace I suspect.
