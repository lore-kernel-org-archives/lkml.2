Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1H3Rpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:45:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29570 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab1H3Rpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:45:49 -0400
Message-ID: <4E5D210D.3040608@oracle.com>
Date: Tue, 30 Aug 2011 10:42:37 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Zach Brown <zab@zabbo.net>, Dave Chinner <david@fromorbit.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@zeniv.linux.org.uk,
        dchinner@redhat.com
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110825060632.GA9933@infradead.org> <20110825064039.GO3162@dastard> <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca> <20110826013528.GW3162@dastard> <CANGUGtC1qk2Tkv42fvibUKiEJz_MnNiV-nQ7T-_woppVhjQK-Q@mail.gmail.com> <20110826144124.GA17519@lulu.zabbo.net> <4E58AB28.1080009@gmail.com>
In-Reply-To: <4E58AB28.1080009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4E5D21A8.0006,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2011 01:30 AM, Marco Stornelli wrote:
> Il 26/08/2011 16:41, Zach Brown ha scritto:
>>>> Hole: a range of the file that contains no data or is made up
>>>> entirely of  NULL (zero) data. Holes include preallocated ranges of
>>>> files that have not had actual data written to them.
>>
>>> No for me. A hole is made up of zero data? It's a strange definition
>>> for me.
>>
>> It's a very natural definition for me.  It mirrors the behaviour of
>> read() of sparse data inside i_size that file system authors already
>> have to consider.
>>
>> It's also a reminder for people that this interface is about avoiding
>> reading zeros.  Systems that track contents can do this for files that
>> had tons of zeros written.  The data is there but the app is
>> specifically asking us to skip it by using SEEK_DATA.
>>
>> - z
>>
>
> I think we need to consider a hole and "data not present/not written yet" as two different cases even they are related. For example, if I do an fallocate without keep size option, then I do a read, I have the same behavior of sparse data inside i_size, but the blocks are allocated so no sparse data in this case. Simply there are no difference from app point of view.

Exactly. That's why seek_hole should identify them alike, if possible.
But that should not be a requirement because the sole aim here is
to improve performance. Identifying a hole as data is not the end of
the world. In some cases it may be more efficient. We just have to
ensure that we don't identify data as a hole.

BTW, we still have the fiemap interface that allows users to identify
unwritten extents, etc. Use that if you want that kind of detail.
