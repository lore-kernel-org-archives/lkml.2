Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab2IKPNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:13:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48025 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab2IKPNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <87oblc4u6f.fsf@devron.myhome.or.jp>
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	<20120904161747.GJ23464@ZenIV.linux.org.uk>
	<CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	<87harc34d9.fsf@devron.myhome.or.jp>
	<CAKYAXd-8aztDe1QiFT=NSQX8J+h_FM+cAWwo+Q+fUQHpNGTctw@mail.gmail.com>
	<87y5knz6l5.fsf@devron.myhome.or.jp>
	<CAKYAXd_mxq26bhRYd-YM9OBjYMO12TD4wHxm6PqHBLjgGFHaZg@mail.gmail.com>
	<CAKYAXd-QtSYy4SQErVTXrxcv=YhFzhOm3PKpj=HoZKmpAG7vGQ@mail.gmail.com>
	<1347020137.2223.13.camel@iscandar.digidescorp.com>
	<87oblfpmnb.fsf@devron.myhome.or.jp>
	<87k3w3ph8d.fsf@devron.myhome.or.jp>
	<CAKYAXd-k4yVV3h8k0kcFMsyGnOVckYRjXi8fkZrLtjuWVi7Eqw@mail.gmail.com>
	<87har6kmfx.fsf@devron.myhome.or.jp>
	<CAKYAXd-ZNmCbHqmFX=YXti7XprhD_Hgvmnd=TnKPVoFc88Sc4A@mail.gmail.com>
	<87oblc4u6f.fsf@devron.myhome.or.jp>
Date: Wed, 12 Sep 2012 00:13:29 +0900
Message-ID: <CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/11 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> Since rename() will be disabled on stable ino patches, this will be
>>> unfixable, so rather maybe it is worse.
>> Currently with our patchset : only rename issue (could not find any
>> correct approach to ignore this. If we do not update this immediately
>> at i_pos change – it is just delaying the problem). And we can return
>> EBUSY when rename is called while process is opening file with rename
>> limitation. Without our patchset also - the rename issue can occur
>> over NFS file access - when the inode is evicted from the SERVER
>> cache.
>
> Important difference is whether rename issue is unfixable or not.
Currently I don't have any idea to fix rename issue in -mm.
>
>> I think that it is unfixable because we can not know i_pos of inode
>> changed by rename.
>> And even though we know it, there is no rebuild inode routine in -mm.
>> And It even can not fix in our patches.
>
>>> And are you tried https://lkml.org/lkml/2012/6/29/381 patches? It sounds
>>> like to improve performance by enabling lookupcache.
>> We checked this patches when facing estale issue in -mm.
>> But It is no use, these patches just retry system call one more when
>> estale error.
>
> What happens if client retried from lookup() after -ESTALE? (client NFS
> doesn't have the name of entry anymore?)
Need to rebuild inode routine because inode cache is already evicted on Server.
>
> I'm assuming the retry means - it restarts from building the NFS file
> handle. I might be just wrong here though.
As I remember, just retry in VFS of NFS client..I heard this patch is
needed for
a very specific set of circumstances where an entry goes stale once
between the lookup and the actual operation(s).
It is not related with current issues(inode cache eviction on server).
>
>>> I'd like to be knowing the critical reason we have to replace it.
>> I arrange to help your decision as the following.
>>
>> 1. lookup cache is enable at default in NFS. So estale error can be
>> easily occurred in -mm.
>> 2. If lookup cache is disable, there is rename issue and file lookup
>> performance is dropped in -mm.
>> 4. If we use our patches, there is rename issue. but we can use VFAT
>> over NFS with lookup cache enable.
>> 5. If we use read-only with our patches, there is no issue.
>
> Again, I'm care about whether rename issue is unfixable or not.
I think that It is unfixable in -mm.
>In stable ino patches, it will never be fixable.
>
>
> What do you think about this rename issue, Steven?
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
