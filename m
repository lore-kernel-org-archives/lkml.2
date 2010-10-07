Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0JGUN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:13:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab0JGUN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:13:56 -0400
Message-ID: <4CAE29CC.8030702@redhat.com>
Date: Thu, 07 Oct 2010 22:13:00 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100914 Thunderbird/3.1.3
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        just.for.lkml@googlemail.com, hch@infradead.org,
        herbert@gondor.hengli.com.au
Subject: Re: [dm-devel] Linux 2.6.36-rc7
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <4CAE1F47.3050105@kernel.org>
In-Reply-To: <4CAE1F47.3050105@kernel.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 09:28 PM, Tejun Heo wrote:

> I'm afraid there is a possibly workqueue related deadlock under high
> memory pressure.  It happens on dm-crypt + md raid1 configuration.
> I'm not yet sure whether this is caused by workqueue failing to kick
> rescuers under memory pressure or the shared workqueue is making an
> already existing problem more visible and in the process of setting up
> an environment to reproduce the problem.
> 
>  http://thread.gmane.org/gmane.comp.file-systems.xfs.general/34922/focus=1044784

Yes, XFS is very good to show up problems in dm-crypt:)

But there was no change in dm-crypt which can itself cause such problem,
planned workqueue changes are not in 2.6.36 yet.
Code is basically the same for the last few releases.

So it seems that workqueue processing really changed here under memory pressure.

Milan

p.s.
Anyway, if you are able to reproduce it and you think that there is problem
in per-device dm-crypt workqueue, there are patches from Andi for shared
per-cpu workqueue, maybe it can help here. (But this is really not RC material.)

Unfortunately not yet in dm-devel tree, but I have them here ready for review:
http://mbroz.fedorapeople.org/dm-crypt/2.6.36-devel/
(all 4 patches must be applied, I hope Alasdair will put them in dm quilt soon.)
