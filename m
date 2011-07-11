Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab1GKSAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:00:17 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:42908 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1GKSAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:00:15 -0400
X-ASG-Debug-ID: 1310407196-01de280c1ebc4e0002-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E1B3A1D.2050400@fusionio.com>
Date: Mon, 11 Jul 2011 19:59:57 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: block: try-2 (modified): Initialize bi_rw in mpage so
  bio_add can make use of it.
References: <CAFR8uec5MxvHEWS=hgRXo1eunjQqWrpPCVXthdGMfWR+Yitw_A@mail.gmail.com>	<4E1B37B1.9030608@fusionio.com> <CAFR8ueetLzSwTEc7D1zW4Yhd8t8iFbKvjJ07onWVQJbhzSOXLQ@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH]: block: try-2 (modified): Initialize bi_rw in mpage so
  bio_add can make use of it.
In-Reply-To: <CAFR8ueetLzSwTEc7D1zW4Yhd8t8iFbKvjJ07onWVQJbhzSOXLQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310407201
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68631
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-11 19:52, Muthu Kumar wrote:
>> For this particular case, doing it when the bio is allocated makes more
>> sense. That will avoid a similar error in there in the future.
>>
> 
> Sounds good. Thanks. How about for other cases that alloc a new bio
> and do bio_add_page() - like blkdev_issue_zeroout() and similar.
> Should we add there too?

Good question, ideally the allocator should be passed in the rw argument
since we need it before even submitting it for the merge cases. We don't
have _that_ many callers of bio_alloc() or bio_kmalloc(), so probably
the best option is just to bite the bullet and change the prototypes to
take the 'rw' argument there. Oh, and the bioset variants, too.
bio_init() should be passed the 'rw' argument from the allcators, so we
catch any private use of that, too.

-- 
Jens Axboe

