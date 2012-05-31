Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2EaHRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:17:54 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57269 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2EaHRr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Thu, 31 May 2012 03:17:47 -0400
Message-Id: <4FC737370200007800087119@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 31 May 2012 08:17:43 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Andre Przywara" <andre.przywara@amd.com>,
        "Jacob Shin" <jacob.shin@amd.com>, <mingo@elte.hu>, <jeremy@goop.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com>
 <20120530144851.GA12184@jshin-Toonie>
 <20120530145005.GI3207@phenom.dumpdata.com>
 <20120530150334.GA13349@jshin-Toonie>
 <20120530171754.GA5115@phenom.dumpdata.com>
In-Reply-To: <20120530171754.GA5115@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.05.12 at 19:17, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> I am tempted to write a patch that checks all the pv-cpu-ops
> to see if there are any that are NULL and throw a warning so
> that this does not hit us in the future - to be at least more
> proactive about this sort of thing.

Perhaps rather than using C99 initializers, using old-style ones
would be an alternative (assuming that the signatures of the
respective entries [or at least immediately neighboring ones]
are different), with a sentinel that is required to remain last
(i.e. adding at the very end would be prohibited)?

Or rather than doing a full structure assignment, assign
individual members directly to pv_cpu_ops (thus leaving
everything that's not explicitly overridden at its "native"
default)? After all, this is being done on __init code, so the
few extra code bytes shouldn't matter much? (All this of
course in the context of hpa's valid request that there be
no unused paravirt hooks in the first place.)

Jan

