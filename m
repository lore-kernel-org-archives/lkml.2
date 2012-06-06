Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2FFPWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:22:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46051 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab2FFPWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:22:43 -0400
Date: Wed, 6 Jun 2012 17:22:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v6 2/2] x86 mce: use new printk recursion disabling
 interface
Message-ID: <20120606152238.GA3874@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	ShuoX Liu <shuox.liu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"andi@firstfloor.org" <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>
References: <4FC2E944.6060903@intel.com>
 <20120604171202.GA8533@x1.osrc.amd.com>
 <1338856360.14538.220.camel@ymzhang.sh.intel.com>
 <20120605081448.GA7097@liondog.tnic>
 <4FCDD72A.9030701@intel.com>
 <4FCDD78A.3070106@intel.com>
 <20120605151542.GA10669@x1.osrc.amd.com>
 <1338942965.14538.233.camel@ymzhang.sh.intel.com>
 <4FCF155B.3090705@intel.com>
 <4FCF160D.8010404@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FCF160D.8010404@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 04:34:21PM +0800, ShuoX Liu wrote:
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
> Here in mce_panic, we choose to disable printk recursion to make sure
> MCE logs printed out.

Just a minor nitpick: this should say "print_mce" or you can simply
remove the whole sentence - commit message is fine without it too.

Aside of that, those look ok to me.

Thanks.

-- 
Regards/Gruss,
Boris.
