Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab0FWNG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:06:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0FWNGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:06:25 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3 v5][RFC] ext3/4: enhance fsync performance when using CFQ
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<4C21D442.8080703@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 23 Jun 2010 09:06:18 -0400
In-Reply-To: <4C21D442.8080703@oracle.com> (Tao Ma's message of "Wed, 23 Jun
	2010 17:30:42 +0800")
Message-ID: <x49iq59q4ol.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tao.ma@oracle.com> writes:

> Hi Jeff,
>
> On 06/23/2010 05:34 AM, Jeff Moyer wrote:
>> Hi,
>>
>> Running iozone with the fsync flag, or fs_mark, the performance of CFQ is
>> far worse than that of deadline for enterprise class storage when dealing
>> with file sizes of 8MB or less.  I used the following command line as a
>> representative test case:
>>
>>    fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096 -F
>>
>> When run using the deadline I/O scheduler, an average of the first 5 numbers
>> will give you 448.4 files / second.  CFQ will yield only 106.7.  With
>> this patch series applied (and the two patches I sent yesterday), CFQ now
>> achieves 462.5 files / second.
> which 2 patches? Could you paste the link or the subject? Just want to
> make my test env like yours. ;)
> As Joel mentioned in another mail, ocfs2 also use jbd/jbd2, so I'd
> like to give it a try and give you some feedback about the test.

http://lkml.org/lkml/2010/6/21/307:

[PATCH 1/2] cfq: always return false from should_idle if slice_idle is
set to zero
[PATCH 2/2] cfq: allow dispatching of both sync and async I/O together

Thanks in advance for the testing!

-Jeff
