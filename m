Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1BUQ5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:57:25 -0500
Received: from mail-vw0-f42.google.com ([209.85.212.42]:62978 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1BUQ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:57:24 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Feb 2011 11:57:23 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NDzgn/2+NGxrOuhkJ3NZO2XPdcEvBL7/QcJZGqlzx8iOAmk06+ek8qfYY5ud6MtfSw
         VqzYaqmDl3NIvL1ITOTDunMn9VM12WEplm+JxWmieh2dzQG9ARbeLoQK4rn8/Ipmc9rS
         d9rdnpZ8HTb5OUTtylCoJ3Kl+9vfWBsytKxjs=
MIME-Version: 1.0
In-Reply-To: <20110221124635.GA5525@infradead.org>
References: <4D6221B8.9040303@gmail.com>
	<20110221124635.GA5525@infradead.org>
Date: Mon, 21 Feb 2011 17:50:21 +0100
Message-ID: <AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/21 Christoph Hellwig <hch@infradead.org>:
> On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> All fs must check for the immutable flag in their fallocate callback.
>> It's possible to have a race condition in this scenario: an application
>> open a file in read/write and it does something, meanwhile root set the
>> immutable flag on the file, the application at that point can call
>> fallocate with success. Only Ocfs2 check for the immutable flag at the
>> moment.
>
> Please add the check in fs/open.c:do_fallocate() so that it covers all
> filesystems.
>
>

The check should be done after the fs got the inode mutex lock.

Marco
