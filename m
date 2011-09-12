Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab1ILOM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab1ILOM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:12:57 -0400
Subject: Re: [PATCH 10/24] C6X: time management
From: Mark Salter <msalter@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ming.lei@canonical.com, stern@rowland.harvard.edu
Date: Mon, 12 Sep 2011 10:12:44 -0400
In-Reply-To: <alpine.LFD.2.02.1109091612150.2723@ionos>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <1314826019-22330-11-git-send-email-msalter@redhat.com>
	 <alpine.LFD.2.02.1109091612150.2723@ionos>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1315836765.11280.1.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-09 at 16:19 +0200, Thomas Gleixner wrote:
> On Wed, 31 Aug 2011, Mark Salter wrote:
> > +	cd->cpumask		= cpumask_of(smp_processor_id());
> > +
> > +	clockevents_register_device(cd);
> > +
> > +	/* Set handler */
> > +	if (cd->irq != NO_IRQ)
> 
> How does a timer device work w/o interrupt ?

Heh, not very well. That check needs to happen earlier so we don't
register the device if we can't find the irq number.

--Mark


