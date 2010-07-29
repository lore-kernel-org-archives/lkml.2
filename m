Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab0G2TkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:40:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab0G2Tj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:39:57 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Heinz Diehl <htd@fancy-poultry.org>,
        linux-kernel@vger.kernel.org, jaxboe@fusionio.com, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com,
        "Ted Ts'o" <tytso@mit.edu>
Subject: Re: cfq fsync patch testing results (Was: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new group_idle tunable)
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
	<20100723140343.GA8478@fancy-poultry.org>
	<20100723141303.GB13104@redhat.com>
	<20100723145631.GA8844@fancy-poultry.org>
	<20100723183720.GD13104@redhat.com>
	<20100724080613.GA6554@fancy-poultry.org>
	<20100728202212.GD16314@redhat.com>
	<20100728235716.GA12945@infradead.org>
	<20100729043443.GB21736@redhat.com>
	<20100729145632.GC25863@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 29 Jul 2010 15:39:37 -0400
In-Reply-To: <20100729145632.GC25863@redhat.com> (Vivek Goyal's message of
	"Thu, 29 Jul 2010 10:56:32 -0400")
Message-ID: <x49lj8uxekm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Jul 29, 2010 at 12:34:43AM -0400, Vivek Goyal wrote:
>> On Wed, Jul 28, 2010 at 07:57:16PM -0400, Christoph Hellwig wrote:
>> > On Wed, Jul 28, 2010 at 04:22:12PM -0400, Vivek Goyal wrote:
>> > > I also did "time firefox &" testing to see how long firefox takes to
>> > > launch when linus torture test is running and without patch it took
>> > > around 20 seconds and with patch it took around 17 seconds. 
>> > > 
>> > > So to me above test results suggest that this patch does not worsen
>> > > the performance. In fact it helps. (at least on ext3 file system.)
>> > > 
>> > > Not sure why are you seeing different results with XFS.
>> > 
>> > So why didn't you test it with XFS to verify his results?
>> 
>> Just got little lazy. Find the testing results with ext3, ext4 and
>> xfs below.
>> 
>> >  We all know
>> > that different filesystems have different I/O patters, and we have
>> > a history of really nasty regressions in one filesystem by good meaning
>> > changes to the I/O scheduler.
>> > 
>> > ext3 in fact is a particularly bad test case as it not only doesn't have
>> > I/O barriers enabled, but also has particularly bad I/O patterns
>> > compared to modern filesystems.

A string of numbers is hard for me to parse.  In the hopes that this
will help others, here is some awk-fu that I shamelessly stole from the
internets:

awk '{total1+=$3; total2+=$6; array1[NR]=$3; array2[NR]=$6} END{for(x=1;x<=NR;x++){sumsq1+=((array1[x]-(total1/NR))**2); sumsq2+=((array2[x]-(total2/NR))**2);}print total1/NR " " sqrt(sumsq1/NR) " " total2/NR " " sqrt(sumsq2/NR)}'

>> Ext3 results
>> ============
>> ext3 (2.6.35-rc6)	ext3 (35-rc6-fsync)
>> -----------------	-------------------
avg     stddev           avg       stddev
3.8953  2.80654          0.587943  1.22399

>> 
>> XFS results
>> ==========
>> XFS (2.6.35-rc6)	XFS (with fsync patch)
2.2538 0.95565          2.11869 0.649704

>> Ext4
>> ====
>> ext4 (vanilla)		ext4 (patched)
8.57177 9.54596                 9.41524 10.4037

> ext3 (barrier=1)	ext3 (barrier=1)
2.40316 1.26992         1.82272 0.922305

It is interesting that ext4 does worse with the patch (though,
realistically, not by much).

Cheers,
Jeff
