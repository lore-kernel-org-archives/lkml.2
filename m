Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1JJQ1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:27:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53433 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919Ab1JJQ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:27:50 -0400
Date: Mon, 10 Oct 2011 17:25:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <mgross@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Subject: Re: [Question] PM-QoS: PM_QOS_CPU_DMA_LATENCY == interrupt latency?
Message-ID: <20111010172557.332bfe30@lxorguk.ukuu.org.uk>
In-Reply-To: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
References: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 22:31:34 +0800
Ming Lei <tom.leiming@gmail.com> wrote:

> Hi,
> 
> Looks like it is a bit difficult to understand PM_QOS_CPU_DMA_LATENCY
> from the words' meaning.
> 
> After searching from google, I don't find some useful information about
> the root cause for introducing PM_QOS_CPU_DMA_LATENCY. I understand
> it is very similar to interrupt latency. Also from the comment for
> omap_pm_set_max_mpu_wakeup_lat in file[1], the description is basically same
> with interrupt latency.
> 
> >From comments of pm_qos_add_request usages in drivers, it can be understood
> as interrupt latency too, IMO.
> 
> So, could we think that PM_QOS_CPU_DMA_LATENCY is interrupt latency?

No. Well it may be on some platforms but it isn't the same thing. On some
devices a DMA transfer doesn't need the CPU involved but needs the CPU to
respond within a set timescale (eg for coherency or bus arbitration). It
is not the same thing as IRQ latency.
