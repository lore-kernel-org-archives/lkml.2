Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1CRUjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:39:53 -0400
Received: from www.tglx.de ([62.245.132.106]:58550 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291Ab1CRUjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:39:48 -0400
Date: Fri, 18 Mar 2011 21:39:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Esben Haabendal <eha@doredevelopment.dk>
cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Subject: Re: [PATCH] Support IRQ_NOAUTOEN flag in set_irq_chained_handler()
In-Reply-To: <1300435389-11048-1-git-send-email-eha@doredevelopment.dk>
Message-ID: <alpine.LFD.2.00.1103182135260.2787@localhost6.localdomain6>
References: <1300435389-11048-1-git-send-email-eha@doredevelopment.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011, eha@doredevelopment.dk wrote:

> From: Esben Haabendal <eha@doredevelopment.dk>
> 
> Handle IRQ_NOAUTOEN in __set_irq_handler() (ie. for
> set_irq_chained_handler()) instead of just silently ignoring it, and in
> the same way as is done in __setup_irq() (ie. request_irq()).
> 
> This give a more consistent interface, and also adheres better to
> the rule of least surprise.

Well, that might be less surprising for you, but you will be surprised
that such a change would be a real big surprise for all users of
chained handlers in arch/arm. They simply would not work anymore.

So we _cannot_ change the semantics here. All we can do is document
it.

Thanks,

	tglx
