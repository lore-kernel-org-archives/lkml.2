Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0F0Nse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 09:48:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab0F0Nsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 09:48:33 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       "ocfs2-devel\@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using CFQ
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<4C21D442.8080703@oracle.com> <4C22F316.3080009@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Sun, 27 Jun 2010 09:48:25 -0400
In-Reply-To: <4C22F316.3080009@oracle.com> (Tao Ma's message of "Thu, 24 Jun
	2010 13:54:30 +0800")
Message-ID: <x49k4pk60ye.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tao.ma@oracle.com> writes:

> Hi Jeff,
>
> On 06/23/2010 05:30 PM, Tao Ma wrote:
>> Hi Jeff,
>>
>> On 06/23/2010 05:34 AM, Jeff Moyer wrote:
>>> Hi,
>>>
>>> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
>>> far worse than that of deadline for enterprise class storage when dealing
>>> with file sizes of 8MB or less. I used the following command line as a
>>> representative test case:
>>>
>>> fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w
>>> 4096 -F
>>>
>>> When run using the deadline I/O scheduler, an average of the first 5
>>> numbers
>>> will give you 448.4 files / second. CFQ will yield only 106.7. With
>>> this patch series applied (and the two patches I sent yesterday), CFQ now
>>> achieves 462.5 files / second.
>> which 2 patches? Could you paste the link or the subject? Just want to
>> make my test env like yours. ;)
>> As Joel mentioned in another mail, ocfs2 also use jbd/jbd2, so I'd like
>> to give it a try and give you some feedback about the test.
> I am sorry to say that the patch make jbd2 locked up when I tested
> fs_mark using ocfs2.
> I have attached the log from my netconsole server. After I reverted
> the patch [3/3], the box works again.

I can't reproduce this, unfortunately.  Also, when building with the
.config you sent me, the disassembly doesn't line up with the stack
trace you posted.

I'm not sure why yielding the queue would cause a deadlock.  The only
explanation I can come up with is that I/O is not being issued.  I'm
assuming that no other I/O will be completed to the file system in
question.  Is that right?  Could you send along the output from sysrq-t?

Cheers,
Jeff
