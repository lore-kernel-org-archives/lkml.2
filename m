Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423344Ab2LGRhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:37:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423269Ab2LGRhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:37:08 -0500
Message-ID: <50C22923.90102@redhat.com>
Date: Fri, 07 Dec 2012 12:36:35 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121126025520.GC22858@thunk.org> <20121126091202.GO32450@dastard> <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com> <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com>
In-Reply-To: <20121207011628.GB16373@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 08:16 PM, Ingo Molnar wrote:
> * Christoph Hellwig <hch@infradead.org> wrote:
>
>> No, the problem is that the thing is not just a) wrong, but b)
>> only made it in through sneaky ways.
> People disagree with a), and b) only really matters if a) is
> true.
>
> You never gave a technical reason for why protecting against
> future ABI clashes is 'wrong'. It looks like a marginally
> useful, practical patch to me.
>
> Thanks,
>
> 	Ingo
>

Hi Ingo,

The historical roots of the argument are not quite as clear here as you posit 
above. The need for the interface/ABI itself was the subject of the review.

The interface proposed - expose any deleted data without zeroing it - was 
requested not to enable a tool or fix a specific need. It was proposed in order 
to avoid tripping over an ext4 performance problem that occurs when we change 
allocated-but-unwritten extents into allocated and written.

This is a huge break with very long standing file system semantics - normally, 
we always promise to return to the application only data that you wrote or 
return zeroed blocks of data if you allocated it and did not write it.

This allows you to fallocate all unused space on disk, seek around and poke for 
other peoples' deleted data.  Aside from the obvious violation of expected 
privacy of deleted data (for non-root users at least), it could also break 
things that have the original expectations in place.

After LSF, we did try to reproduce the use case (not with a lot of success) and 
had several proposed ways to fix the ext4 performance challenge instead of using 
this hack to avoid it.

I would prefer to fix the performance issue in ext4 rather than add an interface 
that has no actual users of the actual feature - it exists for applications that 
want to avoid an unfortunate performance hit from something that we could work 
around.

If there are legitimate needs to expose the data to non-root users, it would be 
good to have that debate in the open and clarify the correct interface.

The process issue exposed is not one where "bike shedding" occurred - the 
proposed feature was discussed in person at LSF and on the mailing lists and 
debated and rejected.

Review is part of the way we work as a community and we should figure out how to 
fix our review process so that we can have meaningful results from the review or 
we lose confidence in the process and it makes it much harder to get reviewers 
to spend time reviewing when their reviews are ultimately ignored.

Regards,

Ric




