Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab1EUEVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 00:21:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37342 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1EUEVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 00:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=syGwDQ6vR9FXMjSD7ewhx5Bv10VHShY+P2hmEZKo0JbGct8TqxO5nfG5xlJ3y0fyjO
         VkDBR6VKDRoxrBmaSd4aHXtFphTcWxxavn4k2DUl7+Joux/ZRJeS9YppI8lj08OjxH1N
         1NUjVHCQDWsvywyAMFl1N+sf9aP04aWCxm+I8=
MIME-Version: 1.0
In-Reply-To: <4DD68BE0.6030003@panasas.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
 <1305840792-25877-9-git-send-email-jim.cromie@gmail.com> <4DD68BE0.6030003@panasas.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 20 May 2011 22:21:00 -0600
Message-ID: <BANLkTi=6qWpUX6wMi5egRhi+qigaGPgnFQ@mail.gmail.com>
Subject: Re: [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org,
        Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 9:42 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 05/20/2011 12:33 AM, Jim Cromie wrote:
>> cc: Doug Gilbert <dgilbert@interlog.com>
>> cc: linux-scsi@vger.kernel.org
>> cc: Benny Halevy <bhalevy@panasas.com>
>> cc: Boaz Harrosh <bharrosh@panasas.com>
>> cc: osd-dev@open-osd.org
>> cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
>> cc: linux-scsi@vger.kernel.org
>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>> ---
>>  drivers/scsi/osd/osd_uld.c |    6 +++---
>>  drivers/scsi/pmcraid.c     |    3 +--
>>  drivers/scsi/sg.c          |    6 +++---
>>  drivers/scsi/st.c          |    7 +++----
>>  4 files changed, 10 insertions(+), 12 deletions(-)
>
> Do you have a git tree with all these that I can pull
> and test?
>

I do, its at git://github.com/jimc/linux-2.6.git  chrdev-pub1 branch

For you, I think there are 3 patches of interest
1 - adds new call, deprecates old.
if you build with this applied and CONFIG_ENABLE_WARN_DEPRECATED=y
you should get a deprecated warning
2 - reimplements alloc_chardev_region() with register_chardev_ids()
your driver may be using register_chardev_region(), if so this is uninteresting.
3 - patch that adapts your scsi parts.

> Thanks
> Boaz
>

no, thank you
Jim Cromie
