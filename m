Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab2IKPr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:47:28 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:37581 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab2IKPr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:47:27 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
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
	<CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
Date: Wed, 12 Sep 2012 00:47:22 +0900
In-Reply-To: <CAKYAXd-gO5Pw=0unjB=YQJhu6W=g7VpZYnmHXkve-k8_4VjpgA@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 12 Sep 2012 00:13:29 +0900")
Message-ID: <871ui84l4l.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> I think that it is unfixable because we can not know i_pos of inode
>>> changed by rename.
>>> And even though we know it, there is no rebuild inode routine in -mm.
>>> And It even can not fix in our patches.
>>
>>>> And are you tried https://lkml.org/lkml/2012/6/29/381 patches? It sounds
>>>> like to improve performance by enabling lookupcache.
>>> We checked this patches when facing estale issue in -mm.
>>> But It is no use, these patches just retry system call one more when
>>> estale error.
>>
>> What happens if client retried from lookup() after -ESTALE? (client NFS
>> doesn't have the name of entry anymore?)
> Need to rebuild inode routine because inode cache is already evicted on Server.
>>
>> I'm assuming the retry means - it restarts from building the NFS file
>> handle. I might be just wrong here though.
> As I remember, just retry in VFS of NFS client..I heard this patch is
> needed for
> a very specific set of circumstances where an entry goes stale once
> between the lookup and the actual operation(s).
> It is not related with current issues(inode cache eviction on server).

Supposing, the server/client state is after cold boot, and client try to
rename at first without any cache on client/server.

Even if this state, does the server return ESTALE? If it doesn't return
ESTALE, I can't understand why it is really unfixable.

If it returns ESTALE, why does it return? I'm assuming the previous code
path is the cached FH path.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
