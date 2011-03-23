Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1CWWJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:09:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:39070 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618Ab1CWWJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:09:37 -0400
Date: Wed, 23 Mar 2011 23:09:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Daney <ddaney.cavm@gmail.com>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] genirq: Add chip hooks for taking CPUs on/off
 line.
In-Reply-To: <4D8A6E38.7020203@gmail.com>
Message-ID: <alpine.LFD.2.00.1103232304240.31464@localhost6.localdomain6>
References: <1300484916-11133-1-git-send-email-ddaney@caviumnetworks.com> <1300484916-11133-2-git-send-email-ddaney@caviumnetworks.com> <alpine.LFD.2.00.1103192050400.2787@localhost6.localdomain6> <4D879869.8060405@caviumnetworks.com>
 <alpine.LFD.2.00.1103212136430.24415@localhost6.localdomain6> <4D8A6E38.7020203@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, David Daney wrote:
> On 03/21/2011 02:13 PM, Thomas Gleixner wrote:
> > I can't imagine any other purpose for that.
> 
> Modifying the affinity of non-per-cpu IRQs to use the new CPU?

Hmm. Good point. Ok, go ahead with that name.

> > Hmm. The offline fixup_irq() code is arch specific and usually calls
> > desc->irq_data.chip->irq_set_affinity under desc->lock. I have not yet
> > found an arch independent way to do that. Any ideas welcome.
> > 
> 
> There are all the new affinity callbacks, and the things shown in procfs?  Are
> those handled properly if I call chip->irq_set_affinity?  I think not.

If the arch code updates irq_data.affinity then yes. I still need to
go through all that maze and figure out what all the archs really want
to do in that case.

Thanks,

	tglx
