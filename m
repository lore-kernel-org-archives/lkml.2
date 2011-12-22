Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1LVWJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 17:09:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1LVWJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 17:09:00 -0500
Message-ID: <4EF3AA74.1060801@redhat.com>
Date: Thu, 22 Dec 2011 23:08:52 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition
 devices
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com> <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com> <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com> <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
In-Reply-To: <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2011 09:52 PM, Linus Torvalds wrote:
> On Thu, Dec 22, 2011 at 12:23 PM, Paolo Bonzini<pbonzini@redhat.com>  wrote:
>>
>> I disagree.  ENOTTY is perfect in all cases except the compat_ioctl (which
>> I'm not denying is ugly, but beautifying it would make everything else
>> ugly).
>
> No it's not.
>
> ENOTTTY isn't ever perfect. We should never have used it to begin with
> inside the kernel.
>
> Why would it make *anything* else uglier? Just return it, don't try to
> change it anywhere. Does it break anything?

I don't know.  But given the ways in which earlier versions broke during 
testing, I wouldn't be able to tell before running many tests.  Which 
with the Christmas break would easily mean a little less than 2 weeks.

>> Secondarily, ENOIOCTLCMD is ultimately turned into EINVAL when the system
>> call returns (not ENOTTY).
>
> That's a completely independent bug that has been discussed several
> times. We probably should just bite the bullet and fix it. EINVAL is
> never the right return value (unless the per-ioctl arguments
> themselves are invalid, not for bad ioctls).

Makes a lot of sense and I was wondering about it myself, but I'm not 
sure stable would accept that.

I understand that it's kind of backwards to commit as is and cleanup 
later, but it's also backwards to force all distros and stable to 
deviate from upstream for the sake of cleaning up.

> The EINVAL return comes from some people who didn't understand that
> ENOTTY means "no such ioctl" despite the name.

I did. :)

Paolo
