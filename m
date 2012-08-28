Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2H1LEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:04:33 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60813 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2H1LEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:04:32 -0400
Message-ID: <503CA5BA.2040003@redhat.com>
Date: Tue, 28 Aug 2012 13:04:26 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: axboe@kernel.dk
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com> <50195108.1090105@redhat.com>
In-Reply-To: <50195108.1090105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/08/2012 17:53, Paolo Bonzini ha scritto:
> Il 20/07/2012 18:30, Paolo Bonzini ha scritto:
>> These commands cannot be issued right now without giving CAP_SYS_RAWIO to
>> the process who wishes to send them.  These commands can be useful also to
>> non-privileged programs who have access to the block devices.  For example
>> a virtual machine monitor needs them to forward trim/discard to host disks.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  block/scsi_ioctl.c |    3 ++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
>> index 260fa80..dd71f18 100644
>> --- a/block/scsi_ioctl.c
>> +++ b/block/scsi_ioctl.c
>> @@ -168,13 +168,16 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
>>  	/* Basic writing commands */
>>  	__set_bit(WRITE_6, filter->write_ok);
>>  	__set_bit(WRITE_10, filter->write_ok);
>> +	__set_bit(WRITE_SAME, filter->write_ok);
>>  	__set_bit(WRITE_VERIFY, filter->write_ok);
>>  	__set_bit(WRITE_12, filter->write_ok);
>>  	__set_bit(WRITE_VERIFY_12, filter->write_ok);
>>  	__set_bit(WRITE_16, filter->write_ok);
>> +	__set_bit(WRITE_SAME_16, filter->write_ok);
>>  	__set_bit(WRITE_LONG, filter->write_ok);
>>  	__set_bit(WRITE_LONG_2, filter->write_ok);
>>  	__set_bit(ERASE, filter->write_ok);
>> +	__set_bit(UNMAP, filter->write_ok);
>>  	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
>>  	__set_bit(MODE_SELECT, filter->write_ok);
>>  	__set_bit(LOG_SELECT, filter->write_ok);
>>
> 
> Jens,
> 
> can this go in 3.6 as well?

Another ping...

Paolo

