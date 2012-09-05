Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab2IEF1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:27:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:59660 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab2IEF1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:27:34 -0400
Message-ID: <1346822819.2257.49.camel@pasglop>
Subject: Re: [PATCH v5 3/3] powerpc: Uprobes port to powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: ananth@in.ibm.com
Cc: ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, peterz@infradead.org,
        michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>, oleg@redhat.com
Date: Wed, 05 Sep 2012 15:26:59 +1000
In-Reply-To: <20120824073132.GC32031@in.ibm.com>
References: <20120824072602.GA32031@in.ibm.com>
	 <20120824073132.GC32031@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 13:01 +0530, Ananth N Mavinakayanahalli wrote:
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> This is the port of uprobes to powerpc. Usage is similar to x86.

Guys, can you do a minimum of build testing ?

This one breaks due to uprobe_get_swbp_addr() being defined in both
asm and include/linux when CONFIG_UPROBE isn't set. You don't need
to define it at all in fact, the generic code takes care of both the
declaration for CONFIG_UPROBE and the empty inline for !CONFIG_UPROBE.

I'm fixing that one up myself but please, please, get yourself a test
build script or something to make sure you don't at least break the
build when the stuff you're adding isn't enabled (among others).

Cheers,
Ben.


