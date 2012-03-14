Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479Ab2CNVB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:01:27 -0400
Received: from dwdmx5.dwd.de ([141.38.3.242]:55405 "EHLO dwdmx5.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802Ab2CNVBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:01:25 -0400
Date: Wed, 14 Mar 2012 21:01:20 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Shaohua Li <shli@kernel.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
In-Reply-To: <CANejiEXnYpKx741LDs9SzrQKKpfmguO2WFkzWemtiMPtZH0ODA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1203142042330.6232@diagnostix.dwd.de>
References: <20120312030412.375458948@fusionio.com> <alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de> <4F5EFEB6.4060402@kernel.org> <alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de> <CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
 <alpine.LRH.2.02.1203131521190.29286@diagnostix.dwd.de> <CANejiEW=a1piMYvSYM5GmtxKsWYpZj+kjnmNsNUDmW9ydDBjBw@mail.gmail.com> <alpine.LRH.2.02.1203140839590.28358@diagnostix.dwd.de> <CANejiEXP9ORKTfE4O9khaHSp-Y8yOQU1LLUD5Q5pBJOGR+A-aA@mail.gmail.com>
 <CANejiEXnYpKx741LDs9SzrQKKpfmguO2WFkzWemtiMPtZH0ODA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Shaohua Li wrote:

> Is it possible if you can directly build a fs in such ssd (that is not
> using raid), and check
> the performance of discard? I'd like to make sure it's not the problem
> of the ssd itself.
>
Yes, I just did the test on a partition without raid on the same SSD.
Then there is hardly any difference if using discard or not. So it is not
the problem of the SSD.

It must be hanging somewhere in kernel. I once had an strace running
on a rm command that was deleting thousand of small files and even the
output of the strace command was stuck:

   18:31:19.776588 unlinkat(7, "2K-3-4-16--207", 0) = 0
   18:31:19.776699 unlinkat(7, "2K-3-4-16--44", 0) = 0
   18:31:19.776808 unlinkat(7, "2K-3-4-16--1476", 0) = 0
   18:31:19.776919 unlinkat(7, "2K-3-4-16--1277", 0

And when it continued after several minutes being frozen, the time
given by strace was still 18:31:19.xxxx as if it did not hang.

These hang occur when deleting lots of small files. But they not only
effect the process doing the deleting, other process are also effected.
When I tried to open a file on a tmpfs disk in another shell it too
was stuck for several minutes.

Regards,
Holger
