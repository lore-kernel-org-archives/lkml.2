Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab2EaP7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:59:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53510 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673Ab2EaP7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:59:47 -0400
Message-ID: <4FC79558.4000403@zytor.com>
Date: Thu, 31 May 2012 08:59:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andre Przywara <andre.przywara@amd.com>,
        Jacob Shin <jacob.shin@amd.com>, mingo@elte.hu, jeremy@goop.org,
        tglx@linutronix.de, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com> <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com> <20120530144851.GA12184@jshin-Toonie> <20120530145005.GI3207@phenom.dumpdata.com> <20120530150334.GA13349@jshin-Toonie> <20120530171754.GA5115@phenom.dumpdata.com> <4FC737370200007800087119@nat28.tlf.novell.com>
In-Reply-To: <4FC737370200007800087119@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 12:17 AM, Jan Beulich wrote:
>>>> On 30.05.12 at 19:17, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> I am tempted to write a patch that checks all the pv-cpu-ops
>> to see if there are any that are NULL and throw a warning so
>> that this does not hit us in the future - to be at least more
>> proactive about this sort of thing.
> 
> Perhaps rather than using C99 initializers, using old-style ones
> would be an alternative (assuming that the signatures of the
> respective entries [or at least immediately neighboring ones]
> are different), with a sentinel that is required to remain last
> (i.e. adding at the very end would be prohibited)?
> 
> Or rather than doing a full structure assignment, assign
> individual members directly to pv_cpu_ops (thus leaving
> everything that's not explicitly overridden at its "native"
> default)? After all, this is being done on __init code, so the
> few extra code bytes shouldn't matter much? (All this of
> course in the context of hpa's valid request that there be
> no unused paravirt hooks in the first place.)
> 

Actually there is a really easy way to do this with C99 initializers:
create a macro with all the default assignments, and put that one first.
 This is because it is legal to have more than one C99 initializer for
the same member, the last one is the one that takes effect.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

