Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab2FHMeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 08:34:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59793 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756167Ab2FHMeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 08:34:03 -0400
Date: Fri, 8 Jun 2012 14:34:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: ShuoX Liu <shuox.liu@intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v7 2/2] x86 mce: use new printk recursion disabling
 interface
Message-ID: <20120608123402.GB10978@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	ShuoX Liu <shuox.liu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"andi@firstfloor.org" <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20120605081448.GA7097@liondog.tnic>
 <4FCDD72A.9030701@intel.com>
 <4FCDD78A.3070106@intel.com>
 <20120605151542.GA10669@x1.osrc.amd.com>
 <1338942965.14538.233.camel@ymzhang.sh.intel.com>
 <4FCF155B.3090705@intel.com>
 <4FCF160D.8010404@intel.com>
 <20120606152238.GA3874@x1.osrc.amd.com>
 <4FD01896.1010506@intel.com>
 <4FD01933.7070000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FD01933.7070000@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 11:00:03AM +0800, ShuoX Liu wrote:
> From: ShuoX Liu <shuox.liu@intel.com>
> 
> On x86 machines, some times MCE happens just when kernel calls printk
> to output some log info to serial console, while usually MCE module in
> kernel is used to print out some hardware error information, such like
> bad cache or bad memory bank. That causes printk recursion and printk
> would omit MCE printk output.
> 
> We hit it when running MTBF testing on Android ATOM mobiles.
> 
> Here in print_mce, we choose to disable printk recursion to make sure
> MCE logs printed out.
> 
> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>

Ok,

those patches have to go in hand in hand and since the first one touches
generic code, maybe Andrew is the right guy for the job of picking them
up, provided there are no other objections against them.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

Thanks.

-- 
Regards/Gruss,
Boris.
