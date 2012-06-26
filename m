Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab2FZUnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:43:12 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:35760 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab2FZUnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:43:11 -0400
Date: Tue, 26 Jun 2012 22:43:06 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>, ShuoX Liu <shuox.liu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v7 2/2] x86 mce: use new printk recursion disabling
 interface
Message-ID: <20120626204305.GA29439@aftab.osrc.amd.com>
References: <4FCDD78A.3070106@intel.com>
 <20120605151542.GA10669@x1.osrc.amd.com>
 <1338942965.14538.233.camel@ymzhang.sh.intel.com>
 <4FCF155B.3090705@intel.com>
 <4FCF160D.8010404@intel.com>
 <20120606152238.GA3874@x1.osrc.amd.com>
 <4FD01896.1010506@intel.com>
 <4FD01933.7070000@intel.com>
 <20120625091734.GA25839@gmail.com>
 <1340630061.2507.61.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340630061.2507.61.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 03:14:21PM +0200, Peter Zijlstra wrote:
> That already does bust_spinlocks() which already increments the
> oops_in_progress thing, so WTF are you doing anyway?

Hmm, that's interesting. So Shuox said they hit this in some sort of
"MTBF testing on Android ATOM mobiles":

http://marc.info/?l=linux-kernel&m=133903834107577&w=2

And I'm guessing they want this probably because they set fake_panic so
that we don't bust_spinlocks() in mce_panic().

Shoux, Yanmin, what's the dealio here?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
