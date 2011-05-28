Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1E1RV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:21:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49806 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1E1RV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OeZcY5ZLyi6X/Qp3bwPdE8NSHbfZbp9gZmbhb1vE0rLImU45KDmM+NW5teCn+n1XAR
         +cdh9X65ITo2BMR776B2e4k+e6W6lNt5+YURhiV2AxbesCmU7SiilS6Aj/YdYV2pNgdU
         u4XsENjdFOtEGtzpnY7/QC6cmDgQSkAuavwOY=
MIME-Version: 1.0
In-Reply-To: <20110527164702.GB28520@samba2>
References: <BANLkTinVOaFwkCf33iKNk8GjqiiBEF5N3w@mail.gmail.com>
	<20110527164702.GB28520@samba2>
Date: Sat, 28 May 2011 12:21:55 -0500
Message-ID: <BANLkTik1vW-PnEiaSfLnr0pWhr_rFLTowQ@mail.gmail.com>
Subject: Re: Big performance improvements seen with cifs async write patches
 even over localhost
From: Steve French <smfrench@gmail.com>
To: Jeremy Allison <jra@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:47 AM, Jeremy Allison <jra@samba.org> wrote:
> On Fri, May 27, 2011 at 12:14:19AM -0500, Steve French wrote:
>> Did some informal testing of Jeff Layton's cifs async_write patch set
>> tonight (recent kernel). Copying 700MB sequentially was 20% faster
>> from cifs kernel client to Samba 3.6 with his patches - even mounted
>> over localhost (where network latency is a much smaller issue) and
>> with a slow laptop drive!
>>
>> I was simply doing
>>
>> time dd if=/dev/zero of=/mnt/null bs=1M count=700
>>
>> repeated 4 times each way (with old module, and with same code with
>> Jeff's cifs async write code builtin), deleting the target file in
>> between each run.
>>
>> I am looking forward to trying this over GigE tomorrow to servers with
>> faster disks.
>
> Very nice ! Now where's my encrypted transport Steve ? :-) :-)
>
> Jeremy.

Did some additional informal testing with this (current mainline vs.
cifs from 2.6.39) and the results are even better.

Mounted over GiGE to midrange desktop system from my laptop.  Copying
2.5GB to the server was 88% faster with current mainline.   Repeated
the test 3 times each way.  Current mainline cifs averaged 98.9 MB/s
for sequential file copy vs. 52.6 MB/s (for 2.6.39 and older).

stevef@stevef-laptop:~$ time dd if=/dev/zero of=/mnt/null bs=1M count=2500
2500+0 records in
2500+0 records out
2621440000 bytes (2.6 GB) copied, 26.3095 s, 99.6 MB/s

real	0m27.201s
user	0m0.000s
sys	0m3.340s




-- 
Thanks,

Steve
