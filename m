Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2IHKSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 06:18:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50526 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab2IHKSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 06:18:10 -0400
Message-ID: <504B1B58.4030103@redhat.com>
Date: Sat, 08 Sep 2012 12:18:00 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Justin M. Forbes" <jmforbes@linuxtx.org>, Jan Beulich <JBeulich@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Matt Wilson <msw@amazon.com>, xen-devel@lists.xen.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com> <504A05B00200007800099C7B@nat28.tlf.novell.com> <5049F4E9.9050306@canonical.com> <504A1A950200007800099D4C@nat28.tlf.novell.com> <20120907142251.GA20096@linuxtx.org> <20120907145433.GA5378@phenom.dumpdata.com>
In-Reply-To: <20120907145433.GA5378@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2012 16:54, Konrad Rzeszutek Wilk ha scritto:
>>> But iirc that bad patch is a Linux side one (i.e. you're trying to fix
>>> something upstream that isn't upstream)?
>>>
>> Right, so the patch that this improves upon, and that Fedora and Ubuntu are
>> currently carrying is not upstream because:
>>
>> a) It's crap, it cripples upstream xen users, but doesn't impact RHEL xen
>> users because xsave was never supported there.
>>
>> b) The hypervisor was patched to make it unnecessary quite some time ago,
>> and we hoped EC2 would eventually pick up that correct patch and we could
>> drop the crap kernel patch.
>>
>> Unfortunately this has not happened. We are at a point where EC2 really is
>> a quirk that has to be worked around. Distros do not want to maintain
>> a separate EC2 build of the kernel, so the easiest way is to cripple
>> current upstream xen users.  This quirk is unfortunately the best possible
>> solution.  Having it upstream also makes it possible for any user to build
>> an upstream kernel that will run on EC2 without having to dig a random
>> patch out of a vendor kernel.
> 
> Sure. Jan is asking though for actual confirmation that the upstream kernel
> does indeed go belly up without a workaround.
> And whether this patch (which I would did since Canonical is carrying it) does
> fix the issue.
> 
> I am still a newbie on the Amazon EC2 upload your kernel thing (hint, would
> appreciate somebody taking this patch and trying it out).

You can just pick an old version of the CentOS kernel package, for
example 2.6.18-128.el5 or 2.6.18-164.el5 (respectively CentOS/RHEL 5.3
and 5.4).

Paolo

