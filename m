Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2FNA5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:57:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54009 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2FNA5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:57:10 -0400
Message-ID: <4FD936E4.6070904@gmail.com>
Date: Thu, 14 Jun 2012 10:57:08 +1000
From: Jason Stubbs <jasonbstubbs@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Matt Wilson <msw@amazon.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: PROBLEM: Possible race between xen, md, dm and/or xfs
References: <4FD1918A.2060908@gmail.com> <20120612035737.GL22848@dastard> <4FD731F9.8070509@gmail.com> <20120614001855.GA2136@US-SEA-R8XVZTX>
In-Reply-To: <20120614001855.GA2136@US-SEA-R8XVZTX>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-6-14 10:18 , Matt Wilson wrote:
> On Tue, Jun 12, 2012 at 05:11:37AM -0700, Jason Stubbs wrote:
>> I'll be sure to give Amazon ample opportunity to diagnose things from
>> there side should the issue occur again and hopefully there won't be
>> any more people reporting extraneous issues.
> 
> If you're able to reproduce this hang, I'm sure that we can get to the
> root of the problem quite quickly. Short of that, if you can provide a
> running instance that is exhibiting the problem we can do some
> live-system debugging. It is much more difficult to determine root
> cause and verify fixes without reproduction instructions.

We've got about 50 instances using the same disk layout, but have only
been running these new instances for a couple of months. We've been
using EC2 and EBS for three years now though, which is why I thought
it was likely something to do with the disk layout of the new instances.
Thinking that, my first concern was to get the instance working again
to keep the service running smoothly.

Come to think of it though, I think I might have had this issue once
before with EBS. Still, that makes two occurrences in somewhere around
70 years combined uptime, so it was either a one off or a very rare
corner case.

Either way, I think all that can be done is to wait for it to happen
again, at which time I'll take it out of production, leave it running
and set up a new instance for production instead.

> Given the kernel version you reported in your traces, I can at least
> rule out one known bug that caused blkfront to wait forever for an IO
> to complete: 
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=dffe2e1
> 
> The kernel version you're using using includes the follow-on change to
> use fasteoi:
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=3588fe2

Yep, this is exactly the sort of corner case I though it might be.
I've confirmed that this change against the sources for the kernel
I'm using, though.

> I'm sorry that I can't be more of more immediate help. If you
> encounter the problem again, please contact developer support.

No problem. We have a support contract and I did go there first, but
the response was basically that nothing can be done without the instance
running. I supplied the traces, but it wasn't clear whether they'd
actually been investigated or not, hence I chose to report here. 
In hindsight, I realize I should have kept the instance running, but
I don't tend to think so clearly when it's the middle of the night. ;)

As for not being able to solve the problem, I don't mind at all. I just
wanted to make sure that an adequate attempt had been made to solve the
problem. We "architect for failure" as much as possible, so the problem
in itself is not such a big deal. Thanks for looking into it!

--
Regards,
Jason Stubbs
