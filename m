Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1JXXDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 19:03:39 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62975 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab1JXXDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 19:03:38 -0400
MIME-Version: 1.0
In-Reply-To: <20111024225459.GB25654@redhat.com>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
	<1319496149.2094.3.camel@Joe-Laptop>
	<CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
	<20111024225459.GB25654@redhat.com>
Date: Tue, 25 Oct 2011 01:03:36 +0200
Message-ID: <CAFLxGvwMEmjyifB-_Ms5Xd8iAr+GCVbYk0RX5Qxwev1nyXpFUw@mail.gmail.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in pmcraid_chr_ioctl()
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Dave Jones <davej@redhat.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Joe Perches <joe@perches.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:54 AM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Oct 25, 2011 at 12:50:08AM +0200, richard -rw- weinberger wrote:
>
>  > BTW: What about a checkpatch.pl rule to detect such a misuse of kmalloc()?
>  > We could grep for "k[mzc]alloc(GFP_".
>
> Make sure to ignore bio_kmalloc (which has reverse argument order to kmalloc, ugh)
>

Hmmm, maybe we should "fix" the argument order of bio_kmalloc().
But as this function is exported we'd silently break some out-of-tree
kernel modules....

-- 
Thanks,
//richard
