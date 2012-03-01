Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab2CAWpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:45:52 -0500
Received: from mail-qy0-f179.google.com ([209.85.216.179]:37696 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab2CAWpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:45:51 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2012 17:45:51 EST
Authentication-Results: mr.google.com; spf=pass (google.com: domain of anthony@xtfx.me designates 10.224.208.1 as permitted sender) smtp.mail=anthony@xtfx.me; dkim=pass header.i=anthony@xtfx.me
MIME-Version: 1.0
X-Originating-IP: [24.106.62.130]
In-Reply-To: <1330639448.7414.97.camel@marge.simpson.net>
References: <20120221211938.GE12236@google.com> <20120222163858.GB4128@redhat.com>
 <20120222165714.GC4128@redhat.com> <1329990094.24994.64.camel@twins>
 <1330006399.11248.20.camel@twins> <4F4FAF89.3090706@redhat.com>
 <1330633603.7414.49.camel@marge.simpson.net> <20120301210213.GF13533@redhat.com>
 <1330639448.7414.97.camel@marge.simpson.net>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Thu, 1 Mar 2012 16:38:37 -0600
Message-ID: <CAGAVQTE8JSPNimS_HU9-p8dCz2jw40YUEDwkU0BSn_ZZg_PhRA@mail.gmail.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org,
        Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Lennart Poettering <lennart@poettering.net>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 4:04 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Thu, 2012-03-01 at 16:02 -0500, Vivek Goyal wrote:
>> On Thu, Mar 01, 2012 at 09:26:43PM +0100, Mike Galbraith wrote:
>
>> > Q: you say systemd requires CONFIG_CGROUPS=y.  Why is that?  It's taking
>> > over sysvinits job afaiui, what does that have to do with cgroups?
>>
>> I think they were using it to track all the children forked by a service
>> and cleanup all of them if need be. So they just need it for logical
>> grouping functionality and don't require any controllers as such.
>
> Hm.  Controllers are perhaps not required, but cpu controller was
> configured and used without consent.  I didn't receive an offer.

AFAIK it does in fact only require `name` cgroup for it's own
monitoring purposes.  i believe the systemd folks also tried (and are
trying? see TODO) to get PR_SET_ANCHOR merged upstream:

https://lkml.org/lkml/2010/2/2/165

... which is a sort of recursive/persistent parenting flag; without
that or cgroups, there is no way to reliably supervise processes under
Linux.

the other problem is there is no way for a process to enumerate the
available cgroups -- IIRC a list had to be hard-coded in systemd
sources -- and mounting the cgroupfs without specifying a specific
subsystem simply mounts everything in one whack.

you should be able to tell systemd to ignore that specific controller,
or tell it to use existing mounts.  i for one have been using it
*exclusively* on my personal machines/home servers [archlinux] and am
very pleased ... it's very flexible and gives you an unprecedented
level of control and introspection into the system (man systemd.*) ...
i can create new services in about 3-5 lines.

... obviously this thread is not about systemd, but since it makes
such extensive use of cgroup facilities it only proves to highlight
it's deficiencies.  i think the notes and practices systemd has
established should be viewed as a good reference for what's clumsy, at
the very least, and should not be attributed to systemd, but to
cgroups.

-- 

C Anthony
