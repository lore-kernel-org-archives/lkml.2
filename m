Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1IDRpD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 13:45:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45430 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1IDRpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 13:45:00 -0400
Message-ID: <88f8907569619968aa7b4a8c669d5aba.squirrel@www.firstfloor.org>
In-Reply-To: <yq14o0scjmg.fsf@sermon.lab.mkp.net>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
    <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
    <20110902182214.GC12086@tux1.beaverton.ibm.com>
    <yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
    <6fdb58aed1dae8020900e65cbfb34b28.squirrel@www.firstfloor.org>
    <yq14o0scjmg.fsf@sermon.lab.mkp.net>
Date: Sun, 4 Sep 2011 19:44:55 +0200
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
From: "Andi Kleen" <andi@firstfloor.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Andi Kleen" <andi@firstfloor.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, djwong@us.ibm.com,
        "Greg Freemyer" <greg.freemyer@gmail.com>,
        "Andreas Dilger" <adilger.kernel@dilger.ca>,
        "Theodore Tso" <tytso@mit.edu>,
        "Sunil Mushran" <sunil.mushran@oracle.com>,
        "Amir Goldstein" <amir73il@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Mingming Cao" <cmm@us.ibm.com>, "Joel Becker" <jlbec@evilplan.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, "Coly Li" <colyli@gmail.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>> "Andi" == Andi Kleen <andi@firstfloor.org> writes:
>
>>> On Westmere and beyond it is possible to accelerate generic CRC
>>> calculation using the PCLMULQDQ operation. There are many of our CRC
>
> Andi> Faster than the lookup table? That's hard to believe.
>
> Using PCLMULQDQ you can parallelize the calculation. You can even boost
> hw CRC32C performance that way.
>
>   http://download.intel.com/design/intarch/papers/323405.pdf
>
>   http://download.intel.com/design/intarch/papers/323102.pdf

Doesn't have any performance numbers.

You need to keep in mind that PCLMULQDQ uses FPU state, so any
speedup for the kernel must be large enough to amortize the cost of
saving the FPU state.

Typically that only works out for quite large buffers, but
kernel buffers are relatively small.

For the ext4 metadata a better approach is probably some sort of
incremental CRC, or possibly separate CRCs for very commonly
changed fields. When I looked at this most changes were only for
small fields.

-Andi

