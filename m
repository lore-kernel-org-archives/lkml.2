Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab1FVNV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:21:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53124 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab1FVNV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:21:26 -0400
Date: Wed, 22 Jun 2011 09:21:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Deep Debroy <ddebroy@gmail.com>
Cc: linux-kernel@vger.kernel.org, kraxel@redhat.com
Subject: Re: code sections beyond .text skipped from
 alternatives_smp_module_add
Message-ID: <20110622132114.GA8656@dumpdata.com>
References: <BANLkTi=H17HC29bCTncSbXXm+RjwOCP49g@mail.gmail.com>
 <BANLkTikyjzQ-VZMn2_ZobEmHMLRafki9YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikyjzQ-VZMn2_ZobEmHMLRafki9YQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4E01EC54.00FE:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Looking at the code, in module_finalize for x86, only .text seems to
> > be getting picked for the patching of lock prefixes while other
> > sections such as .exit.text or .init.text are not. Is there a reason
> > we skip the other *.text code sections from the lock patches? Would
> + Gerd Hoffmann who introduced the SMP patching code below back in Jan
> 2006 as part of 2.6.15.

Whoa, long time ago.

> 
> Any comments on why patching of smp_lock prefixes should be restricted
> to .text and not other *.text code sections?

It could be that at that time the .exit.text or .init.text did not exist.

As in, the patching code just hasn't kept up. One way of checking that
is just finding the ancient 2.6.15 code and seeing if there is any
mention of those extra segments.

Do you have a patch to fix this?
