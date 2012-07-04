Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2GDOJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:09:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48807 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab2GDOJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:09:31 -0400
Subject: RE: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <1341409177.2507.117.camel@laptop>
References: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
	 <1341408169.2507.111.camel@laptop>
	 <27240C0AC20F114CBF8149A2696CBE4A10C84B@SHSMSX101.ccr.corp.intel.com>
	 <1341409177.2507.117.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 16:09:17 +0200
Message-ID: <1341410957.2507.120.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 15:39 +0200, Peter Zijlstra wrote:
> > Anyway, in nmi handler, calling printk is dangerous. This patch is for this case.
> 
> But its ugly and decreases reliability..  Your 'solution' is to
> basically ignore serialization and pray, that's not a solution, that's
> gambling. 

If you want to fix it, do something like:

  http://marc.info/?l=linux-kernel&m=132446646923333

