Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1DDSCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:02:07 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:43440 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab1DDSCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:02:05 -0400
X-Greylist: delayed 1701 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Apr 2011 14:02:05 EDT
Message-ID: <4D9A00B1.2080002@cs.columbia.edu>
Date: Mon, 04 Apr 2011 13:32:33 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Nathan Lynch <ntl@pobox.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, Andrew Morton <akpm@osdl.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
References: <1298936432-29607-1-git-send-email-ntl@pobox.com> <1298936432-29607-6-git-send-email-ntl@pobox.com> <20110403190324.GD15044@hallyn.com> <1301929228.31531.39.camel@tp-t61> <20110404151017.GA4857@hallyn.com> <1301931608.31531.49.camel@tp-t61> <20110404162753.GA3456@hallyn.com>
In-Reply-To: <20110404162753.GA3456@hallyn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/04/2011 12:27 PM, Serge E. Hallyn wrote:
> Quoting Nathan Lynch (ntl@pobox.com):
>> On Mon, 2011-04-04 at 10:10 -0500, Serge E. Hallyn wrote:
>>> Quoting Nathan Lynch (ntl@pobox.com):
>>>> On Sun, 2011-04-03 at 14:03 -0500, Serge E. Hallyn wrote:
>>>>> Quoting ntl@pobox.com (ntl@pobox.com):
>>>>>> Only a pid namespace init task - the child process produced by a call
>>>>>> to clone(2) with CLONE_NEWPID - is allowed to call these.  The state
>>>>>
>>>>> So you make this useful for your cases by only using this with
>>>>> application containers - created using lxc-execute, or, more precisely,
>>>>> using lxc-init as the container's init.  So a container running a stock
>>>>> distro can't be checkpointed.
>>>>
>>>> Correct, a conventional distro init won't work, and application
>>>> containers are my focus for now, at least.
>>>>
>>>>
>>>>> Is this just to keep the patch simple for now, or is there some reason
>>>>> to keep this limitation in place?
>>>>
>>>> I guess you're asking whether non-pid-init processes could be allowed to
>>>> use the syscalls?
>>>
>>> No.  I'm asking whether you are intending to later on change the checkpoint
>>> API to allow an external task to checkpoint a pid-init process, rather than
>>> the pid-init process having to initiate it itself.
>>
>> No, that is not the intention.  I can see how that would be problematic
>> for those wanting to run minimally-modified distro containers, but I
>> think running a patched pid-init is a reasonable tradeoff to ask users
>> to make in order to get c/r.  And there's nothing to keep the standard
>> distro inits from growing c/r capability.
> 
> It's not necessarily a dealbreaker, since presumably I can hack the
> needed support into upstart, triggered by a boot option so it isn't
> activated on a host.  But especially given the lack of interest in
> this thread so far, I don't see a point in pushing this, an API-incompatible
> less-capable version of the linux-cr tree.  If it can gain traction
> better than linux-cr, that'd be one thing.  But given the amount of
> review and testing the other tree has gotten - and I realize you're
> able to piggy-back on much of that - and, again, the lack of responses
> so far, I just don't see this as worth pushing for.

First, thanks to Nathan for cleaning up and re-producing a "minimal"
patchest for review.

>From the technical point of view it *is* a big problem:  there are
very good reasons why we chose a certain design. 

If Natahan is suggesting in-kernel tree creation as a temporary thing
to simplify the code for review - then, given that this patch handles
a single process, doing so add lots of unnecessary code, all of which
in the kernel.

If this is the beginning of a permanent approach, then it is totally
incompatible with what we have done so far, and severely restricts 
the kind of use--cases of the project, potentially making it too
unattractive for many natural adaptors, like HPC users. Sorry, nack.

Thanks,

Oren.
