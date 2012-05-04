Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528Ab2EDWp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:45:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52273 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760474Ab2EDWpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <1333580415.23520.29.camel@joe2Laptop>
References: <1333580415.23520.29.camel@joe2Laptop>
Date: Sat, 5 May 2012 00:45:53 +0200
Message-ID: <CAFLxGvyAFMtAZYdAggSB-6-0VPvm_RoVXq3p7FFkLRYXLw2ARQ@mail.gmail.com>
Subject: Re: drivers: Probable misuses of ||
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 1:00 AM, Joe Perches <joe@perches.com> wrote:
> Likely these should be && not ||
>
> drivers/scsi/FlashPoint.c:                              if(bit_cnt != 0 || bit_cnt != 8)

/*
                                if(bit_cnt != 0 || bit_cnt != 8)
                                {
                                        byte_cnt = 0;
                                        bit_cnt = 0;
                                        FPT_scxferc(p_port, SYNC_PTRN);
                                        FPT_scxferc(p_port, ASSIGN_ID);
                                        continue;
                                }
*/

dead code...

-- 
Thanks,
//richard
