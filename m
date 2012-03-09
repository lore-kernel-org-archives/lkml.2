Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab2CIRBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:01:35 -0500
Received: from smtp121.dfw.emailsrvr.com ([67.192.241.121]:42968 "EHLO
	smtp121.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab2CIRBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:01:34 -0500
Message-ID: <4F5A350F.3090905@calxeda.com>
Date: Fri, 09 Mar 2012 10:51:27 -0600
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: linux-next: manual merge of the powerpc tree with the arm tree
References: <20120308120422.e071cba36425eacbee1f8d98@canb.auug.org.au>  <25744.1331174036@neuling.org>  <20120308145131.fad50bbc79c36f0b0b12d101@canb.auug.org.au>  <1331185951.3105.29.camel@pasglop> <1331249746.3105.40.camel@pasglop>  <20120309003937.GC8680@flint.arm.linux.org.uk> <1331262821.3105.47.camel@pasglop>
In-Reply-To: <1331262821.3105.47.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 09:13 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2012-03-09 at 00:39 +0000, Russell King wrote:
>> On Fri, Mar 09, 2012 at 10:35:46AM +1100, Benjamin Herrenschmidt wrote:
>>> Actually, I didn't keep MAY_HAVE_SPARSE_IRQ, I kept HAVE_SPARSE_IRQ. If
>>> I remove it, then I get Kconfig warnings:
>>>
>>> warning: (PPC) selects SPARSE_IRQ which has unmet direct dependencies
>>> (HAVE_GENERIC_HARDIRQS && HAVE_SPARSE_IRQ)
>>
>> Do you have commit 2ed86b16eabe4efbf80cc725a8cbb5310746a2fc ?
> 
> Nope, Grant patch didn't mention a dependency.

My opinion is that SPARSE_IRQ shouldn't be user visible option, and the
simple solution was to just make it hidden. It wasn't clear if this was
desired or not for other arches at the time. There is a mixture of
settings in powerpc defconfigs. SuperH selects it for 32-bit and leaves
it user selectable for 64-bit.

I'm happy to revert adding MAY_HAVE_SPARSE_IRQ and just make SPARSE_IRQ
a hidden option. It really just needs the okay from SuperH folks.

Rob
