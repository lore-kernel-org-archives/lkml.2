Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1HaJF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 05:05:26 -0400
Received: from mail3.vodafone.ie ([213.233.128.45]:11222 "EHLO
	mail3.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1HaJFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 05:05:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAKj4XU5tThVO/2dsb2JhbAAMNqp+AQEFMgFGEAsNCwkWDwkDAgECAUUGDQEHAQG+RYZVBJhRgxKISg
Message-ID: <4E5DF951.4010804@draigBrady.com>
Date: Wed, 31 Aug 2011 10:05:21 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Sunil Mushran <sunil.mushran@oracle.com>
CC: Dave Chinner <david@fromorbit.com>, Andreas Dilger <adilger@dilger.ca>,
        Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk,
        dchinner@redhat.com
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110825060632.GA9933@infradead.org> <20110825064039.GO3162@dastard> <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca> <20110826013528.GW3162@dastard> <4E5D8B8E.8030401@oracle.com> <20110831032932.GI32358@dastard> <4E5DBBFD.5020202@oracle.com>
In-Reply-To: <4E5DBBFD.5020202@oracle.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 05:43 AM, Sunil Mushran wrote:
> On 8/30/2011 8:29 PM, Dave Chinner wrote:
>> And that's -exactly- the ambiguous, vague definition that has raised
>> all these questions in the first place. I was in doubt about whether
>> unwritten extents can be considered a hole, and by your definition
>> that means it should be data. But Andreas seems to be in no doubt it
>> should be considered a hole.
> 
> Fair enough. Let me rephrase.
> 
> Data:
> A range in a file when read could return something other than nulls.
> 
> Hole:
> A range in a file when read only returns nulls.
> 
> Considering preallocated extents only return null, they should
> be considered holes.

I would concur with this.
Treating preallocated extents as holes will allow them to be
processed quickly by `cp` etc.

What we lose is the ability to copy the allocation from src to dst.
But that's less important in comparison, and could probably be done
on a per file rather than per extent basis anyway.
Note preallocation would be good for disk layout and timely ENOSPC.

Note fiemap gives us greater control by distinguishing
holes and empty extents, thus allowing us to both
efficiently copy and maintain allocation.  But that
interface currently requires a sync of the file on some
file systems, which we couldn't enable for performance
reasons in cp.

cheers,
Pádraig.
