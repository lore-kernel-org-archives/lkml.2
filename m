Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1A1SNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:13:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1A1SNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:13:41 -0500
Message-ID: <4D43073C.1040100@redhat.com>
Date: Fri, 28 Jan 2011 13:13:16 -0500
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Lawrence Greenfield <leg@google.com>, "Ted Ts'o" <tytso@mit.edu>,
        Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, joel.becker@oracle.com,
        cmm@us.ibm.com, cluster-devel@redhat.com
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
References: <1289248327-16308-1-git-send-email-josef@redhat.com> <20101109011222.GD2715@dastard> <20101109033038.GF3099@thunk.org> <20101109044242.GH2715@dastard> <20101109214147.GK3099@thunk.org> <20101109234049.GQ2715@dastard> <AANLkTimwmJ_ZoE9oAuA1WGhCgK585jDznqnc6k0=9Ntb@mail.gmail.com> <20110112124431.GP28803@dastard>
In-Reply-To: <20110112124431.GP28803@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 07:44 AM, Dave Chinner wrote:
> On Tue, Jan 11, 2011 at 04:13:42PM -0500, Lawrence Greenfield wrote:
>> On Tue, Nov 9, 2010 at 6:40 PM, Dave Chinner<david@fromorbit.com>  wrote:
>>> The historical reason for such behaviour existing in XFS was that in
>>> 1997 the CPU and IO latency cost of unwritten extent conversion was
>>> significant,
> .....
>
>>>> (Take for example a trusted cluster filesystem backend that checks the
>>>> object checksum before returning any data to the user; and if the
>>>> check fails the cluster file system will try to use some other replica
>>>> stored on some other server.)
>>> IOWs, all they want to do is avoid the unwritten extent conversion
>>> overhead. Time has shown that a bad security/performance tradeoff
>>> decision was made 13 years ago in XFS, so I see little reason to
>>> repeat it for ext4 today....
>> I'd make use of FALLOC_FL_EXPOSE_OLD_DATA. It's not the CPU overhead
>> of extent conversion. It's that extent conversion causes more metadata
>> operations than what you'd have otherwise,
> Yes, that's the "IO latency" part of the cost I mentioned above.
>
>> which means systems that
>> want to use O_DIRECT and make sure the data doesn't go away either
>> have to write O_DIRECT|O_DSYNC or need to call fdatasync().
> Seriously, we tell application writers _all the time_ that they
> *must* use fsync/fdatasync to guarantee their data is on stable
> storage and that they cannot rely on side-effects of filesystem or
> storage specific behaviours (like ext3 ordered mode) to do that job
> for them.
>
> You're suggesting that by introducing FALLOC_FL_EXPOSE_OLD_DATA,
> applications can rely on filesystem/storage specific behaviour to
> guarantee data is on stable storage without the use of
> fdatasync/fsync. Wht you describe is definitely storage specific,
> because volatile write caches still needs the fdatasync to issue a
> cache flush.
>
> Do you see the same conflict here that I do?
>

The very concept seems quite "non-enterprise".  I also agree that the cost of 
maintaining extra mount options (and code) for something that no sane end user 
would ever do seems to be a loss.

Why wouldn't you want to convert the punched hole to an unwritten extent?

Thanks!

Ric

