Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2JBWap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:30:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47018 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab2JBWan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:30:43 -0400
To: Kent Overstreet <koverstreet@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v3 01/26] block: Fix a buffer overrun in bio_integrity_split()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
	<1348526106-17074-2-git-send-email-koverstreet@google.com>
	<20121001212336.GA17165@redhat.com>
	<20121001214241.GE26488@google.com> <20121002140847.GD758@redhat.com>
	<20121002202643.GQ26488@google.com>
Date: Tue, 02 Oct 2012 18:30:28 -0400
In-Reply-To: <20121002202643.GQ26488@google.com> (Kent Overstreet's message of
	"Tue, 2 Oct 2012 13:26:43 -0700")
Message-ID: <yq1wqz833sr.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:

>> > + *bp->bip1.bip_vec = bip->bip_vec[0];
>> > + *bp->bip2.bip_vec = bip->bip_vec[0];
>> 
>> I think this is horrible.

Yep.


>> Why not introduce bvec pointer in bip (like bio), to cover the case
>> when bvec are not inline.

Kent> That's... exactly what the next patch in the series does.

I'm perfectly ok with a patch that introduces the pointer and fixes the
bio_pair case. As long as that's all it does.

-- 
Martin K. Petersen	Oracle Linux Engineering
