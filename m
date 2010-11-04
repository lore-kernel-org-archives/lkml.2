Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab0KDNGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:06:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:57777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0KDNGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:06:38 -0400
Message-ID: <4CD2AFBE.7040403@kernel.org>
Date: Thu, 04 Nov 2010 14:06:06 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Oren Laadan <orenl@cs.columbia.edu>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>	<4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu> <4CD28033.1000700@kernel.org> <987664A83D2D224EAE907B061CE93D53016480D1DE@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53016480D1DE@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Nov 2010 13:06:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/04/2010 01:48 PM, Luck, Tony wrote:
>> If you think only about target processes, yeah sure, you can cover
>> most of the stuff but that's not the impossible part.  What's not
>> defined is interaction with the rest of the system and userland.
>> Userland ecosystem is crazy complex.  You simply cannot stop, say,
>> banshee or even pidgin, let it mingle with the rest of the system and
>> restore it later in any safe way.
> 
> This is why I think it is important to define the limits of
> which kernel state features are covered (or going to be
> covered) by checkpoint/restart - and then list applications
> that are supported (Oren mentioned mysql server in this thread).
> It will always be easy for someone to point at some application
> like powertop and say "we can't migrate that, so checkpoint
> restart is therefore useless" ... this just is not true. This
> can be useful without having to be complete (as long as the
> limits are well defined).
> 
>> I'm afraid I can't agree with that.  You can store and restore the
>> states which kernel is aware of but that's a very small fraction of
>> the whole picture.
> 
> See above - it may be enough to cover a significant number of
> useful cases.

I was arguing that it is far from being _generally_ useful or
transparent.  If you're saying that it is something useful for certain
use cases and application, yeah, sure.  I never argued against that.

>> I'm afraid that's not general or transparent at all.  It's extremely
>> invasive to how a system is setup and used.  It basically is poor
>> man's virtualization or rather partitioning without hardware support
>> and at this point I find it very difficult to justify the added
>> complexity.  Let's just make virtualization better.
> 
> I don't think that you'll ever make virtualization good enough
> to make the HPC people happy.

If you think about HPC, userland implementation is enough.  In 99% of
cases, those programs just read and write data files and burn a lot of
CPU cycles.  You don't need a lot of fancy stuff to do that.  More
important things would be integrating with job management so that
snapshots and rollbacks can be automatically done.

I agree that CR would be very useful for certain use cases and
applications.  I just can't see where the giant patchset fits between
userland implementation which seems enough for the the most common use
case of HPC and virtualization which is maturing fast.

Thanks.

-- 
tejun
