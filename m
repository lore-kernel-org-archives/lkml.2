Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab2B0WxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:53:17 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45076 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2B0WxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:53:16 -0500
Message-ID: <4F4C0955.6060907@oracle.com>
Date: Mon, 27 Feb 2012 16:53:09 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Thunderbird/10.0.2
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/22] loop: Issue O_DIRECT aio with pages
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com> <4F4C036A.2080808@zabbo.net>
In-Reply-To: <4F4C036A.2080808@zabbo.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F4C095B.006F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 04:27 PM, Zach Brown wrote:
> On 02/27/2012 04:19 PM, Dave Kleikamp wrote:
>> This patchset was begun by Zach Brown and was originally submitted for
>> review in October, 2009.
> 
> Man, it's been a while.  I remembered almost none of the details of this
> work when I read your introductory message.  As I read the patches it
> all came flooding back, though.  Yikes :).
> 
> My biggest fear about this patch series is the sheer amount of very
> fiddly code motion.  I remember spending a lot of time verifying that
> the patches didn't accidentally lose new changes as the patches were
> ported to newer kernels.
>
> Has someone gone through these most recent patches with an absurdly fine
> toothed comb?  The patches that touch fs/direct-io.c and mm/filemap.c
> are the most risky, by far.

I was pretty careful porting these patches, trying not to lose the
effects of any newer changes to the affected functions. It wouldn't hurt
to go through them again, but I am putting it out as an RFC since I
don't think these are ready to merge quite yet.

>> This series was written to reduce the current overhead loop imposes by
>> performing synchronus buffered file system IO from a kernel thread. 
>> These
>> patches turn loop into a light weight layer that translates bios into
>> iocbs.
> 
> It'd be worth including some simple benchmark results, I think.  I
> remember testing with concurrent O_DIRECT aio with fio on a loopback
> device on top of files in each underlying file system.

Actually, some preliminary tests I ran showed a significant slowdown. I
suspect it may have to do with the unconditional setting of O_DIRECT,
but I haven't verified that yet. I'll do further performance analysis,
but I wanted to get some eyes on this in the mean time.

Thanks,
Shaggy
