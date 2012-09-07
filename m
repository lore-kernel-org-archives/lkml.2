Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669Ab2IGOBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:01:37 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56629 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab2IGOBg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 7 Sep 2012 10:01:36 -0400
Message-Id: <504A1A950200007800099D4C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 07 Sep 2012 15:02:29 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Stefan Bader" <stefan.bader@canonical.com>
Cc: "Matt Wilson" <msw@amazon.com>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen
 hypervisors
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com>
 <504A05B00200007800099C7B@nat28.tlf.novell.com>
 <5049F4E9.9050306@canonical.com>
In-Reply-To: <5049F4E9.9050306@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.09.12 at 15:21, Stefan Bader <stefan.bader@canonical.com> wrote:
> On 07.09.2012 14:33, Jan Beulich wrote:
>>>>> On 07.09.12 at 13:40, Stefan Bader <stefan.bader@canonical.com> wrote:
>>> When writing unsupported flags into CR4 (for some time the
>>> xen_write_cr4 function would refuse to do anything at all)
>>> older Xen hypervisors (and patch can potentially be improved
>>> by finding out what older means in version numbers) would
>>> crash the guest.
>>>
>>> Since Amazon EC2 would at least in the past be affected by that,
>>> Fedora and Ubuntu were carrying a hack that would filter out
>>> X86_CR4_OSXSAVE before writing to CR4. This would affect any
>>> PV guest, even those running on a newer HV.
>>>
>>> And this recently caused trouble because some user-space was
>>> only partially checking (or maybe only looking at the cpuid
>>> bits) and then trying to use xsave even though the OS support
>>> was not set.
>>>
>>> So I came up with a patch that would
>>> - limit the work-around to certain Xen versions
>>> - prevent the write to CR4 by unsetting xsave and osxsave in
>>>   the cpuid bits
>>>
>>> Doing things that way may actually allow this to be acceptable
>>> upstream, so I am sending it around, now.
>>> It probably could be improved when knowing the exact version
>>> to test for but otherwise should allow to work around the guest
>>> crash while not preventing xsave on Xen 4.x and newer hosts.
>> 
>> Before considering a hack like this, I'd really like to see evidence
>> of the described behavior with an upstream kernel (i.e. not one
>> with that known broken hack patched in, which has never been
>> upstream afaict).
> 
> This is the reason I wrote that Fedora and Ubuntu were carrying it. It never 
> has
> been send upstream (the other version) because it would filter the CR4 write 
> for
> any PV guest regardless of host version.

But iirc that bad patch is a Linux side one (i.e. you're trying to fix
something upstream that isn't upstream)?

Jan

