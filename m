Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1BNPU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:20:27 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:47826 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754097Ab1BNPUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:20:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance:X-Identified-User;
	b=My+P3ZiLxy/ZDJzKE20+OjTJKOJ/krzp9m/PXCaZl8/9zHL0BEz17Rs+U5kFntSSi+M00ygBzId39xqoZ3L14TKlZf3eG19astsMYITO4cTh9UUXtkZs+Q0rBHPCw60n;
Message-ID: <04650f485d5814ddfe6893a3a7c8429b.squirrel@box585.bluehost.com>
In-Reply-To: <20110214120237.GB13052@dastard>
References: <20110213184219.GA22792@infradead.org> <4D5890B6.2090105@tao.ma>
    <20110214120237.GB13052@dastard>
Date: Mon, 14 Feb 2011 08:20:18 -0700
Subject: Re: XFS status update for January 2011
From: tm@tao.ma
To: "Dave Chinner" <david@fromorbit.com>
Cc: "Tao Ma" <tm@tao.ma>, "Christoph Hellwig" <hch@infradead.org>,
        xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1390:box585.bluehost.com:colyli:coly.li} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
> On Mon, Feb 14, 2011 at 10:17:26AM +0800, Tao Ma wrote:
>> Hi Christoph,
>> On 02/14/2011 02:42 AM, Christoph Hellwig wrote:
>> >On the 4th of January we saw the release of Linux 2.6.37, which
>> contains a
>> >large XFS update:
>> >
>> >     67 files changed, 1424 insertions(+), 1524 deletions(-)
>> >
>> >User visible changes are the new XFS_IOC_ZERO_RANGE ioctl which allows
>> >to convert already allocated space into unwritten extents that return
>> >zeros on a read,
>> would you mind describing some scenario that this ioctl can be used. I
>> am
>> just wondering whether ocfs2 can implement it as well.
>
> Zeroing a file without doing IO or having to punch out the blocks
> already allocated to the file.
>
> In this case, we had a couple of different people in cloud storage
> land asking for such functionality to optimise record deletion
> be avoiding disruption of their preallocated file layouts as a
> punch-then-preallocate operation does.
Thanks for the info. yeah, ocfs2 is also used to host images in some cloud
computing environment. So It looks helpful for us too.
>
> If you you have some kind of use for it in ocfs2, then implementing
> the XFS ioctl is not the correct thing to do - using the fallocate
> patch I've had sitting around (since about 15min after creating the
> XFS ioctl) is most likely the right way to proceed....
yeah, Josef has added the punching hole in fallocate, so I guess another
parameter for keeping the blocks during hole punching should be enough for
us. :)

Regards,
Tao

