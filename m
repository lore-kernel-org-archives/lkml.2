Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab2EATEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:04:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab2EATEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:04:54 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v3.4-rc5] block: iocontext->nr_tasks should be initialized to one
References: <1335873936.16988.148.camel@lappy>
	<20120501161729.GV26595@google.com> <4FA0253F.4000302@fusionio.com>
	<20120501180906.GX26595@google.com> <4FA028EE.7020208@fusionio.com>
	<x49wr4vlpn8.fsf@segfault.boston.devel.redhat.com>
	<20120501183610.GD18239@redhat.com>
	<x49sjfjloty.fsf@segfault.boston.devel.redhat.com>
	<20120501185906.GE18239@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 01 May 2012 15:04:49 -0400
In-Reply-To: <20120501185906.GE18239@redhat.com> (Vivek Goyal's message of
	"Tue, 1 May 2012 14:59:06 -0400")
Message-ID: <x49k40vlo32.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, May 01, 2012 at 02:48:41PM -0400, Jeff Moyer wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > On Tue, May 01, 2012 at 02:31:07PM -0400, Jeff Moyer wrote:
>> >
>> > [..]
>> >> > But as to actual users, I really don't know. I agree it's probably not
>> >> > that widely used. If google still had that code search, we could get a
>> >> > better idea :-)
>> >> 
>> >> I know of one project: the venerable dump/restore utility uses CLONE_IO.
>> >
>> > I thought you wrote cooperating queue logic to fix dump as it was not
>> > using CLONE_IO and IO from multiple threads was going in separate 
>> > queues.
>> 
>> That's correct.  I believe I sent the patch for dump before the kernel
>> patch was accepted.  Plus, it can't hurt, right?
>
> Ok, so now you have fixed dump to use CLONE_IO.
>
> So only other user of coop thing remaining potentially is qemu. I was

No, that's not the *only* other potential user.  ;-)  I wouldn't be
surprised if nfsd benefitted from the merging.  I also wouldn't be
surprised if other 3rd party apps did.  Are you trying to make a case to
get rid of the queue merging logic?

> doing some qemu testing where threads were doing IO to nearby area
> but no coop merging was taking place. So not sure in practice how well
> does it work.

Well, that sounds like it warrants further investigation.

> Thought, that's irrlevant for this discussion. Thought of mentioning
> this observation.

If you can provide a reproducer, I'll be happy to take a look.

Cheers,
Jeff
