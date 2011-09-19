Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1ISSoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:44:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab1ISSoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:44:11 -0400
Message-ID: <4E778D77.4070207@redhat.com>
Date: Mon, 19 Sep 2011 12:44:07 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.14
MIME-Version: 1.0
To: Sunil Mushran <sunil.mushran@oracle.com>
CC: mtk.manpages@gmail.com, Josef Bacik <josef@redhat.com>,
        linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Man page doc for SEEK_DATA/SEEK_HOLE
References: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com> <4E77827C.3030202@redhat.com> <4E7789A1.4080501@oracle.com>
In-Reply-To: <4E7789A1.4080501@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 12:27 PM, Sunil Mushran wrote:
> On 09/19/2011 10:57 AM, Eric Blake wrote:
>> Also, it seems a shame that the kernel can fail with EINVAL instead of
>> properly emulating SEEK_HOLE and SEEK_DATA even on file systems with
>> no underlying support for reporting holes.
>>
>
> Why do you say that? If I am reading generic_file_llseek_unlocked()
> correctly, the default behavior is treat offset < i_size as data.

The proposed wording states:

>  .B EINVAL
>  .I whence
> -is not one of
> -.BR SEEK_SET ,
> -.BR SEEK_CUR ,
> -.BR SEEK_END ;
> -or the resulting file offset would be negative,
> +is not valid (this error may be returned if
> +.I whence
> +is
> +.BR SEEK_DATA
> +or
> +.BR SEEK_HOLE
> +and the underlying file system does not support the operation).

I guess it should instead read:

EINVAL whence is not valid (this error may be returned if whence is 
SEEK_DATA or SEEK_HOLE but the kernel does not support the operation).

Given your argument that new enough kernels understand SEEK_DATA and 
SEEK_HOLE for all file systems.

I agree that EINVAL will occur if you compile against new enough glibc 
that exposes the constants, but then run against an older kernel that 
does not yet understand them.  But I want the text to be clarified to be 
bullet-proof that if I am running against kernel 3.1 or newer, the only 
way I will ever get EINVAL for these two constants is if I do something 
else invalid, like a negative offset.

-- 
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org
