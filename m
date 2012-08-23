Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2HWGXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:23:50 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56907 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2HWGXq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 23 Aug 2012 02:23:46 -0400
Message-Id: <5035DA7E020000780008A5E6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 23 Aug 2012 07:23:42 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <konrad@kernel.org>
Cc: <stefano.stabellini@eu.citrix.com>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Q:pt_base in COMPAT mode offset by two pages.
 Was:Re: [PATCH 02/11] xen/x86: Use memblock_reserve for sensitive
 areas.
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
 <1345133009-21941-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1208171835010.15568@kaball.uk.xensource.com>
 <20120820141305.GA2713@phenom.dumpdata.com>
 <20120821172732.GA23715@phenom.dumpdata.com>
 <20120821190317.GA13035@phenom.dumpdata.com>
 <50351DEF020000780009702A@nat28.tlf.novell.com>
 <20120822185519.GA29609@phenom.dumpdata.com>
In-Reply-To: <20120822185519.GA29609@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Konrad Rzeszutek Wilk <konrad@kernel.org> 08/22/12 9:05 PM >>>
>Thinking of just sticking this patch then:

Yeah, that may be best for the moment. Albeit I see no reason why you
shouldn't be able to use your more selective logic, just making it either
deal with only the pt_base == start-of-page-tables case (and fall back to
the current logic alternatively), or figure out the true range.

I'm nevertheless considering to re-arrange the allocation order in the
hypervisor (and to remove the superfluously reserved page covering
what would be the L4), so going with the former, simpler case for the
kernel would be a reasonable option.

Jan

