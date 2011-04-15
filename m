Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1DOVzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:55:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757077Ab1DOVzQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:55:16 -0400
MIME-Version: 1.0
In-Reply-To: <4DA8B3FB.5020401@linux.intel.com>
References: <1302892769.2577.24.camel@schen9-DESK> <4DA8B3FB.5020401@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Apr 2011 14:54:23 -0700
Message-ID: <BANLkTi=Z4N4BmjHZkAFev85YL0a=fji4BA@mail.gmail.com>
Subject: Re: [PATCH] vfs: Fix RCU path walk failiures due to uninitialized
 nameidata seq number for root directory
To: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com, alex.shi@intel.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 2:09 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On 4/15/2011 11:39 AM, Tim Chen wrote:
>>
>> During RCU walk in path_lookupat and path_openat, the rcu lookup
>> frequently failed because when root directory was looked up, seq number
>> was not properly set in nameidata.  We dropped out of RCU walk in
>> nameidata_drop_rcu due to mismatch in directory entry's seq number.  We
>> reverted to slow path walk that need to take references.
>
> Thanks Tim. Adding Andrew, Linus too. IMHO this fix is quite important to
> actually make the fabled RCU dcache work -- without it it's just slower
> because
> it will fallback nearly allways.

Well, only for absolute paths, but yes.

I think all my benchmarking was for thing like "git diff", which are
all about the relative paths and wouldn't have triggered this case.

So this patch does look correct, and yes, should also be stable material for 38.

And it's pretty fundamental. But I'd like to get a few more acks
exactly because it's so fundamental. Al and Nick sadly are both gone.
Anybody else feel like they know something about the path lookup code?

                             Linus
