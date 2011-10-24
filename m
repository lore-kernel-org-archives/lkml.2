Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1JXWuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:50:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44028 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1JXWuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:50:09 -0400
MIME-Version: 1.0
In-Reply-To: <1319496149.2094.3.camel@Joe-Laptop>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
	<1319496149.2094.3.camel@Joe-Laptop>
Date: Tue, 25 Oct 2011 00:50:08 +0200
Message-ID: <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in pmcraid_chr_ioctl()
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:42 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2011-10-25 at 00:38 +0200, Jesper Juhl wrote:
>> The first argument to kmalloc() is the size, the second is
>> flags. pmcraid_chr_ioctl() gets this wrong and swaps the
>> arguments. This patch corrects the mistake.
>>
>> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
>> ---
>>  drivers/scsi/pmcraid.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>>  compile tested only.
>>
>> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
>> index d079f9a..da19bdf 100644
>> --- a/drivers/scsi/pmcraid.c
>> +++ b/drivers/scsi/pmcraid.c
>> @@ -4103,7 +4103,7 @@ static long pmcraid_chr_ioctl(
>>       struct pmcraid_ioctl_header *hdr = NULL;
>>       int retval = -ENOTTY;
>>
>> -     hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
>> +     hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
>>
>>       if (!hdr) {
>>               pmcraid_err("faile to allocate memory for ioctl header\n");
>> --
>> 1.7.7
>>
>>
>
> James seems to be uninterested in picking up
> obvious and trivially correct patches.
>

BTW: What about a checkpatch.pl rule to detect such a misuse of kmalloc()?
We could grep for "k[mzc]alloc(GFP_".

-- 
Thanks,
//richard
