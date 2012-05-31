Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab2EaTBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:01:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23660 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2EaTBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:01:50 -0400
Date: Thu, 31 May 2012 14:54:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        Borislav Petkov <bp@amd64.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/mce: Add mcelog support for Xen
 platform
Message-ID: <20120531185444.GA7557@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
 <20120531161139.GA13939@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351FFB11@SHSMSX101.ccr.corp.intel.com>
 <20120531173137.GA31735@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923352000E2@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923352000E2@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> That's vMCE injection logic.
> > 
> > Are you sure about it? The comments in it speak of piggybacking on
> > the native MCE handling routines. But since that is not used anymore
> > do you need to use a different mechanism?
> 
> What is not used anymore? what's your concern about cvt_gate_to_trap? I really confused here.
> Could you elaborate more?

Well, the mce.c is not involved anymore. So if it we are piggybacking
on the native MCE handling routines - those routines (do_machine_check)
won't deliever the data to your driver anymore? B/c the do_machine_check
is doing mce_log which spools data. But your driver is using a different
system to de-spool the data - and it does not use the mcelog structure
array.

.. snip.
> >> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> >> c/s a01ee165a132fadb57659d26246e340d6ac53265
> > 
> > Which I think the tree is based on too.
> 
> So it would not be stuck?

I've no idea what you mean here. Could you elaborate please?
