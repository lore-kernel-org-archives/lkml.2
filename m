Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab2KUNnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:43:01 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34355 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2KUNm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:42:58 -0500
Date: Wed, 21 Nov 2012 13:47:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ivo Sieben <meltedpianoman@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [REPOST-v2] sched: Prevent wakeup to enter critical section
 needlessly
Message-ID: <20121121134747.261c426a@pyramind.ukuu.org.uk>
In-Reply-To: <CAMSQXEGfQE_vcvk9MvP-aJD2jeF7vU+84yx_fEn==v2Jve9w0A@mail.gmail.com>
References: <1351159974-980-1-git-send-email-meltedpianoman@gmail.com>
	<1353310211-3011-1-git-send-email-meltedpianoman@gmail.com>
	<20121119151050.GA4270@redhat.com>
	<CAMSQXEF9BGBVRRtuz88XFqVmPBdbWisepq4qjah3vM05_7hztw@mail.gmail.com>
	<20121119154940.GA6354@redhat.com>
	<CAMSQXEGfQE_vcvk9MvP-aJD2jeF7vU+84yx_fEn==v2Jve9w0A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But we try to understand your fault scenario: How can the LOAD leak
> into the critical section? As far as we understand the spin_unlock()
> function also contains a memory barrier to prevent such a reordering
> from happening.

It does - it would be very interesting for someone to look at the assembly
if this is making a difference.

Alan
