Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab2GDNju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:39:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:41749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab2GDNjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:39:49 -0400
Subject: RE: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A10C84B@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
	 <1341408169.2507.111.camel@laptop>
	 <27240C0AC20F114CBF8149A2696CBE4A10C84B@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 15:39:37 +0200
Message-ID: <1341409177.2507.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 13:30 +0000, Liu, Chuansheng wrote:
> > Yuck.. and no. This makes sane things like early 8250 serial console less
> > reliable.
> Peter, could you share more? 

You avoid calling console write, this delays writing the output, this
delay might be infinite if the machine is sick enough.

Things like the 8250 early console don't take locks and are fine to
call.

> I took many time to dig out this issue.

Well, it was a known issue.. 

> Anyway, in nmi handler, calling printk is dangerous. This patch is for this case.

But its ugly and decreases reliability..  Your 'solution' is to
basically ignore serialization and pray, that's not a solution, that's
gambling.

