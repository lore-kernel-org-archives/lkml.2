Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab1CILeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:34:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab1CILeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:34:10 -0500
Subject: Re: [BUG] rebuild_sched_domains considered dangerous
From: Peter Zijlstra <peterz@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jesse Larrew <jlarrew@linux.vnet.ibm.com>
In-Reply-To: <1299665998.2308.2753.camel@twins>
References: <1299639487.22236.256.camel@pasglop>
	 <1299665998.2308.2753.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Mar 2011 12:33:49 +0100
Message-ID: <1299670429.2308.2834.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 11:19 +0100, Peter Zijlstra wrote:
> > It appears that this corresponds to one CPU deciding to rebuild the
> > sched domains. There's various reasons why that can happen, the typical
> > one in our case is the new VPNH feature where the hypervisor informs us
> > of a change in node affinity of our virtual processors. s390 has a
> > similar feature and should be affected as well.
> 
> Ahh, so that's triggering it :-), just curious, how often does the HV do
> that to you? 

OK, so Ben told me on IRC this can happen quite frequently, to which I
must ask WTF were you guys smoking? Flipping the CPU topology every time
the HV scheduler does something funny is quite insane. And you did that
without ever talking to the scheduler folks, not cool.

That is of course aside from the fact that we have a real bug there that
needs fixing, but really guys, WTF!
