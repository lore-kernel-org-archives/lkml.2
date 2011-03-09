Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab1CINPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:15:47 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:36610 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab1CINPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:15:44 -0500
Date: Wed, 9 Mar 2011 14:15:48 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Subject: Re: [BUG] rebuild_sched_domains considered dangerous
Message-ID: <20110309141548.722e4f56@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1299670429.2308.2834.camel@twins>
References: <1299639487.22236.256.camel@pasglop>
	<1299665998.2308.2753.camel@twins>
	<1299670429.2308.2834.camel@twins>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Mar 2011 12:33:49 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2011-03-09 at 11:19 +0100, Peter Zijlstra wrote:
> > > It appears that this corresponds to one CPU deciding to rebuild the
> > > sched domains. There's various reasons why that can happen, the typical
> > > one in our case is the new VPNH feature where the hypervisor informs us
> > > of a change in node affinity of our virtual processors. s390 has a
> > > similar feature and should be affected as well.
> > 
> > Ahh, so that's triggering it :-), just curious, how often does the HV do
> > that to you? 
> 
> OK, so Ben told me on IRC this can happen quite frequently, to which I
> must ask WTF were you guys smoking? Flipping the CPU topology every time
> the HV scheduler does something funny is quite insane. And you did that
> without ever talking to the scheduler folks, not cool.
> 
> That is of course aside from the fact that we have a real bug there that
> needs fixing, but really guys, WTF!

Just for info, on s390 the topology change events are rather infrequent.
They do happen e.g. after an LPAR has been activated and the LPAR
hypervisor needs to reshuffle the CPUs of the different nodes.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

