Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1ISS20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 14:28:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35172 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab1ISS2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 14:28:25 -0400
Message-ID: <4E7789A1.4080501@oracle.com>
Date: Mon, 19 Sep 2011 11:27:45 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b3pre Thunderbird/3.1.13
MIME-Version: 1.0
To: Eric Blake <eblake@redhat.com>
CC: mtk.manpages@gmail.com, Josef Bacik <josef@redhat.com>,
        linux-man@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Man page doc for SEEK_DATA/SEEK_HOLE
References: <CAKgNAkhZSb0UfZz7N+gKRQD0r7gnC_3-VCB_ORio8ojczbCDvQ@mail.gmail.com> <4E77827C.3030202@redhat.com>
In-Reply-To: <4E77827C.3030202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E7789C2.00D8:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 10:57 AM, Eric Blake wrote:
> On 09/18/2011 01:07 AM, Michael Kerrisk wrote:
>> +
>> +.BR SEEK_DATA
>> +and
>> +.BR SEEK_HOLE
>> +are nonstandard extensions also present in Solaris.
>
> Looks good to me, but you may also want to link to the proposed wording for mandating SEEK_HOLE/SEEK_DATA in the eventual POSIX Issue 8 (POSIX 2008 is Issue 7):
> http://austingroupbugs.net/view.php?id=415
>
> Also, it seems a shame that the kernel can fail with EINVAL instead of properly emulating SEEK_HOLE and SEEK_DATA even on file systems with no underlying support for reporting holes.
>

Why do you say that? If I am reading generic_file_llseek_unlocked()
correctly, the default behavior is treat offset < i_size as data.
