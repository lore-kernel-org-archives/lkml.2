Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2HLPpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 11:45:40 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:50218 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2HLPpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 11:45:39 -0400
Message-ID: <5027CFA0.1020207@msgid.tls.msk.ru>
Date: Sun, 12 Aug 2012 19:45:36 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: majianpeng <majianpeng@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Don't use static to define "void *p" in show_partition_start().
References: <201208031307389214790@gmail.com> <501B8EBE.5040006@kernel.dk>
In-Reply-To: <501B8EBE.5040006@kernel.dk>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.08.2012 12:41, Jens Axboe wrote:
> On 08/03/2012 07:07 AM, majianpeng wrote:
[]
>> diff --git a/block/genhd.c b/block/genhd.c
>> index cac7366..d839723 100644
>> --- a/block/genhd.c
>> +++ b/block/genhd.c
>> @@ -835,7 +835,7 @@ static void disk_seqf_stop(struct seq_file *seqf, void *v)
>>  
>>  static void *show_partition_start(struct seq_file *seqf, loff_t *pos)
>>  {
>> -	static void *p;
>> +	void *p;
>>  
>>  	p = disk_seqf_start(seqf, pos);
>>  	if (!IS_ERR_OR_NULL(p) && !*pos)
> 
> Huh, that looks like a clear bug. I've applied it, thanks.

It also looks like a -stable material, don't you think?

Thanks,

/mjt

