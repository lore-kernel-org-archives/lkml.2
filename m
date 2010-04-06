Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0DFS1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:27:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428Ab0DFS1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:27:07 -0400
Message-ID: <4BBB7A44.2020300@redhat.com>
Date: Tue, 06 Apr 2010 14:15:32 -0400
From: john cooper <john.cooper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Marc Haber <mh+qemu-devel@zugschlus.de>, john.cooper@redhat.com
Subject: Re: linux-next: Tree for April 1 (virtio_blk warning)
References: <20100401172317.80b6d961.sfr@canb.auug.org.au> <20100401091312.85775242.randy.dunlap@oracle.com> <201004061210.48840.rusty@rustcorp.com.au>
In-Reply-To: <201004061210.48840.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Fri, 2 Apr 2010 02:43:12 am Randy Dunlap wrote:
>> On Thu, 1 Apr 2010 17:23:17 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20100331:
>>
>> drivers/block/virtio_blk.c:228:13: warning: multi-character character constant
>>
>> due to:
>>
>> 	if (cmd == 'VBID') {
> 
> John?  That looks suspiciously like untested code.

It does work as advertised although gcc is obliged to squawk
at multi-byte character constants due to portability concerns.

Note I'd intended that only as an example for the benefit of
completeness in the associated patch set, and to stick out
like a sore thumb of sorts.  Marc Haber had suggested exposing
the id string to the guest userland via /sys which is what I
had expected to displace the loose ioctl example above.  In
fact that discussion is what prodded revisiting this issue in
the first place.

Unsure whether Marc (cc'ed here) is still planning to pursue
that interface so unless I hear something to the contrary in
the next day or so I'll package up a suitable ioctl interface
and forward a patch.  It doesn't hurt to provide ioctl access
to the info in addition to exposing it via /sys, but I'd
hoped the latter would overshadow the need to do so.

-john

-- 
john.cooper@redhat.com
