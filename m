Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab1AZFYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 00:24:42 -0500
Received: from lo.gmane.org ([80.91.229.12]:41281 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab1AZFYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 00:24:41 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] crash_dump: export is_kdump_kernel to modules,
 consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn
Date: Wed, 26 Jan 2011 05:24:27 +0000 (UTC)
Message-ID: <ihob6b$kmn$3@dough.gmane.org>
References: <20110125161052.GA20105@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 17:10:52 +0100, Olaf Hering wrote:

> The Xen PV drivers in a crashed HVM guest can not connect to the dom0
> backend drivers because both frontend and backend drivers are still in
> connected state. To run the connection reset function only in case of a
> crashdump, the is_kdump_kernel() function needs to be available for the
> PV driver modules.
> 
> Consolidate elfcorehdr_addr, setup_elfcorehdr and saved_max_pfn into
> kernel/crash_dump.c Also export elfcorehdr_addr to make
> is_kdump_kernel() usable for modules.
> 
> Leave 'elfcorehdr' as early_param().  This changes powerpc from
> __setup() to early_param().  It adds an address range check from x86
> also on ia64 and powerpc.
> 

Hmm, once we export is_kdump_kernel() I bet some driver will start
to use it to "fix" kdump problem, which definitely is a wrong approach.

I am not familiar with Xen at all, don't know why you have to use
is_kdump_kernel() in this case. You need to persuade people to believe
this is a fix not a workaround. :)

