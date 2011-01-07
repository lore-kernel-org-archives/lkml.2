Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1AGAJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:09:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36455 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1AGAJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:09:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eBPYtH4opauSYWNHiytkATSH9WSG5EX5H5u8nTg+Z6GNoyxefcqRxgMkuI5RCk8ozA
         1y81VkXhmY3fuXOrXbL0IKqOmYqu1MDU147o0bGfX4e4FRnxfCAquOrkvLf7dPVA7foq
         LsydRVcFWRBOSdU2p3HrnOTM37kSXo2Rzml9U=
MIME-Version: 1.0
In-Reply-To: <loom.20110106T030535-794@post.gmane.org>
References: <20110105102534.GA6679@amd>
	<loom.20110106T030535-794@post.gmane.org>
Date: Fri, 7 Jan 2011 11:09:53 +1100
Message-ID: <AANLkTikO68RQW0jzeLDOzRw7Hm15Ho0G9=Bp1KobKsrQ@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
From: Nick Piggin <npiggin@gmail.com>
To: Jongman Heo <jongman.heo@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 1:12 PM, Jongman Heo <jongman.heo@gmail.com> wrote:
> Nick Piggin <npiggin <at> kernel.dk> writes:
>
>>
>> Git tree is here:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
>>
>> Branch is:
>>
>>     vfs-scale-working
>>
>
> I've observed issue with this vfs-scaling patch.
>
> It makes the boot time of my Fedora14 on vmware much slower, while Ubuntu
> (native, not on vmware) has no problem.

Chris also noticed the problem on native hardware, so it looks like it might be
specific to redhat.

http://marc.info/?l=linux-kernel&m=129287788825563&w=2

It's interesting because the rcu-walk path lookup failure even in the worst case
that everything blows up in our face, should be a barely measurable hit -- no
more than about 2x slowdown on something as fast as a path lookup.

So I suspect it is a bug in the sysfs .d_revalidate_rcu conversion. It is a bit
nasty and needs some cleanup anyway.

So what I will do is split those conversions properly so the core code is done
first, and the filesystem conversions done individually after that for better
bisecting. I'll also drop the sysfs conversion (it was mainly useful for my own
testing anyway, and not so performance critical).

I might ping you again to test the sysfs patch if I get keen, after the dust of
this merge window settles :)

Thanks,
Nick
