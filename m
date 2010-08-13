Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493Ab0HMOKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 10:10:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51551 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934288Ab0HMOKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 10:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=Y1Tsgw2kS8MoJ37bk54cpBI1yKus41unBl0ctzNdNFTn59wxi76ru+Behjns2jIkAj
         BbwQVSiqVIFiwXKQKIll/bwuk5TtyT+GTrjPj0LhCxdtf/lvo7BB//CIsguOZAdbVtYZ
         FKxLB72/cB39TwlukkIcuATNJpQ/p/W1gJEMs=
MIME-Version: 1.0
In-Reply-To: <20100813131422.GA615@centrinvest.ru>
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
 <1281652177-23562-3-git-send-email-bchociej@gmail.com> <20100813131422.GA615@centrinvest.ru>
From: Ben Chociej <bchociej@gmail.com>
Date: Fri, 13 Aug 2010 09:10:24 -0500
Message-ID: <AANLkTinQAa=DujQ2Tm1oi2kVqF9z1RX2_M3SCCO_MKZG@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
To: bchociej@gmail.com, chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
        crscott@us.ibm.com, mlupfer@gmail.com, conscott@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a good point, of course. Ideally we would be able to prioritize
data and place them on 15k versus 7.2krpm disks, etc. However you get
to a point where's there's only incremental benefit. For that reason,
the scope of this project was simply to take advantage of SSD and HDD
in hybrid. Of course, you could register the same complaint about the
ZFS SSD caching: why not take advantage of faster vs. slower spinning
disks? Unfortunately it just wasn't in the scope of our 12-week
project here.

That's not to say it *shouldn't* be done in the future, of course!
And, incidentally, you could hack it together at this point by setting
the /sys/block/<blockdev>/queue/rotational flag to 0 and using it like
an SSD. :)

BC

On Fri, Aug 13, 2010 at 8:14 AM, Andrey Panin <pazke@centrinvest.ru> wrote:
> On 224, 08 12, 2010 at 05:29:37PM -0500, bchociej@gmail.com wrote:
>> From: Ben Chociej <bchociej@gmail.com>
>>
>> Modified mkfs.btrfs to add hot data relocation option (-h) which
>> preallocates BTRFS_BLOCK_GROUP_DATA_SSD and
>> BTRFS_BLOCK_GROUP_METADATA_SSD at mkfs time for future use by hot data
>> relocation code.  Also added a userspace function to detect whether a
>> block device is an SSD by reading the sysfs block queue rotational flag.
>
> IMHO this policy is too inflexible. What if I have large array of slow SATA
> disks and some fast SAS ones ?
>
