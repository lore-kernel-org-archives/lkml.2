Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087Ab2LIVh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 16:37:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab2LIVh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 16:37:57 -0500
Message-ID: <50C504A1.1020206@redhat.com>
Date: Sun, 09 Dec 2012 16:37:37 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ric Wheeler <rwheeler@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
References: <1353366267-15629-1-git-send-email-david@fromorbit.com> <20121126025520.GC22858@thunk.org> <20121126091202.GO32450@dastard> <201212051148.28039.Martin@lichtvoll.de> <CA+55aFzgP29WfB1yvnj+Q9-TsbX+b-TCCjTS_vPJ16DxMy6aDQ@mail.gmail.com> <20121206120532.GA14100@infradead.org> <20121207011628.GB16373@gmail.com> <50C22923.90102@redhat.com> <alpine.LFD.2.02.1212070956310.23641@air.linux-foundation.org> <20121207193019.GA31591@home.goodmis.org> <20121207211440.GD29435@thunk.org>
In-Reply-To: <20121207211440.GD29435@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 04:14 PM, Theodore Ts'o wrote:
> On Fri, Dec 07, 2012 at 02:30:19PM -0500, Steven Rostedt wrote:
>> How is this similar? By adding this bit, we removed incentive from a
>> group of developers that have the means to fix the real issue at hand
>> (the performance problem with ext4). Thus, it means that they have a work
>> around that's good enough for them, but the rest of us suffer.
> That assumes that there **is** a way to claw back the performance
> loss, and Chris Mason has demonstrated the performance hit exists with
> xfs as well (950 MB/s vs. 400 MB/s; that's more than a factor of two).
> Sometimes, you have to make the engineering tradeoffs.  That's why
> we're engineers, for goodness sakes.  Sometimes, it's just not
> possible to square the circle.

Keep in mind that no one has tried to retune or adjust XFS (or other file 
systems) for this workload.

>
> I don't believe that the technique of forcing people who need that
> performance to suffer in order to induce them to try to engineer a
> solution which may or may not exist is really the best or fairest way
> to go about things.
>

The proposed solution will not ship in any enterprise distro. Google, I assume, 
would require some specific non-normal user access permission.

That means that this solution will not be usable by the vast majority of users, 
so it is clear that we do need to work on fixing the performance at the root 
instead of plastering over the behaviour.

ric

