Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1CNKyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:54:35 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40620 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab1CNKyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kqYc0Z1WmrPUgQMMz1/CkBIIviX/kIg9VJIKgVccy4eyjxOPEprFGhEP2XZZ4NUYew
         3kWEuOXgNu3jJUQmGTcNwgi6zsT6QpssY8A3+aeB4iK5xlQINpNcHFNQWrRb3UDyimAN
         gHMRoI9OpfXpA5xrdDAjrNmCwCGMySfG6Cz6U=
MIME-Version: 1.0
In-Reply-To: <20110314102426.GA29888@infradead.org>
References: <4D6221B8.9040303@gmail.com>
	<4D6F5473.2070709@gmail.com>
	<20110303213903.GL15097@dastard>
	<20110314102426.GA29888@infradead.org>
Date: Mon, 14 Mar 2011 11:40:26 +0100
Message-ID: <AANLkTi=w2uV_Gy3zOapQishk_qqskQz72p2fnQMQZczx@mail.gmail.com>
Subject: Re: [PATCH v2] Check for immutable flag in fallocate path
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        cluster-devel@redhat.com, xfs@oss.sgi.com,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/14 Christoph Hellwig <hch@infradead.org>:
> On Fri, Mar 04, 2011 at 08:39:03AM +1100, Dave Chinner wrote:
>> WTF?  Why does append mode have any effect on whether we can punch
>> holes in a file or not? There's no justification for adding this in
>> the commit message. Why is it even in a patch that is for checking
>> immutable inodes? What is the point of adding it, when all that will
>> happen is people will switch to XFS_IOC_UNRESVSP which has never had
>> this limitation?
>
> xfs_ioc_space unconditionally rejects inodes with S_APPEND set for
> all preallocation / hole punching ioctls.  This might be overzealous for
> preallocations not changing the size, or just extending i_size, but it's
> IMHO entirely correct for hole punching.
>

xfs_ioc_space is in the ioctl path, but we are talking about the
fallocate path. Both of them calls the xfs_change_file_space, isnt'it?
However we are agree about hole punching, the patch is already in
Linus's git tree.

Marco
