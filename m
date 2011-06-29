Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1F2R3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:29:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19480 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1F2R3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:29:45 -0400
Message-ID: <4E0B60DE.50908@oracle.com>
Date: Wed, 29 Jun 2011 10:29:02 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
CC: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110629065306.GC1026@dastard> <20110629074021.GA26086@infradead.org> <4E0B019E.8080800@draigBrady.com>
In-Reply-To: <4E0B019E.8080800@draigBrady.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4E0B60F5.014F:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 03:42 AM, Pádraig Brady wrote:
> There is the argument, that if this interface can distinguish
> these dirty unwritten extents, then why can't the fiemap interface too?
> The advantage of the fiemap interface is that it can distinguish
> empty extents vs holes. Empty extents will become increasingly common
> I think, given the fragmentation and space guarantee benefits they give.
> It would be cool for cp for example to be able to efficiently copy
> empty extents from source to dest.

I'm not too sure about that. Atleast not enabled by default. Most users
use cp to backup data. Not empty space. In this case, this empty extent
may not even be de-dupable.

Frankly I'd be happier of cp started to exploited fallocate() to create larger
extents before copying data into them. Atleast for the large files.
