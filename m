Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1DTQuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 12:50:32 -0400
Received: from claw.goop.org ([74.207.240.146]:42667 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab1DTQub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 12:50:31 -0400
Message-ID: <4DAF0ECB.8060009@goop.org>
Date: Wed, 20 Apr 2011 09:50:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 2/4] x86,xen: introduce x86_init.mapping.pagetable_reserve
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com> <4DA5EAE4.2060406@linux.intel.com> <alpine.DEB.2.00.1104141218110.22672@kaball-desktop> <4DA70A4A.4030805@zytor.com> <alpine.DEB.2.00.1104141746430.10886@kaball-desktop> <alpine.DEB.2.00.1104181507180.10886@kaball-desktop> <4DAC4DEF.3090200@zytor.com>
In-Reply-To: <4DAC4DEF.3090200@zytor.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 07:42 AM, H. Peter Anvin wrote:
> On 04/18/2011 07:09 AM, Stefano Stabellini wrote:
>> Sorry, I don't mean to be pushy, it is just that I'll be AFK for 12 days
>> starting from next Friday and I think that this issue should really be
>> fixed in time for the 2.6.39 release, otherwise no 2.6.39 kernels will
>> be able to boot on any xen system.
> YOU STILL HAVEN'T PROPOSED ANY SEMANTICS.
>
> The semantics of a hook is a description of what the preconditions are,
> what the postconditions are, and what exactly they are allowed or not
> allowed to do.
>
> This is a real pain to do, *exactly because hooks are a real pain*.
> Most hooks that have been put in has been "oh, just do something at
> point X in the code", which is a case of definition by implementation,
> which is exactly how we ended up with the current mess.

Yeah.  The basic problem is that the change to pagetable setup
introduced a regression when running under Xen.  The foremost
consideration is to fix that regression.

I think the most pragmatic thing to do at this point - as much as it
pains me to say so - is just put in an explicit Xen hook in which does
the right thing, rather than try to prettify it as a general hook, since
it only has one user anyway.

If a second user comes along, when we can talk about generalizing it.

But it would be nice if we could come up with an initial pagetable
construction algorithm that follows the same rules as normal pagetable
management and uses the normal pvops hooks in the normal way so that we
don't need to special case it at all.

    J
