Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2GWQnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:43:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49712 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab2GWQnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:43:41 -0400
Message-ID: <500D7F39.2000506@mev.co.uk>
Date: Mon, 23 Jul 2012 17:43:37 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>
Subject: Re: Bug in UDF, setting larger file size when data in ICB
References: <500D6B87.7070700@mev.co.uk>
In-Reply-To: <500D6B87.7070700@mev.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-23 16:19, Ian Abbott wrote:
> Hi folks,
>
> in fs/udf/inode.c, udf_setsize(), if the new size is larger than the old
> size and the old data is in the ICB and the new size still fits in the
> ICB (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB and iinfo->i_lenAlloc
> = newsize), udf_extend_file() is called which promptly calls BUG()
> because it does not like this i_alloc_type value.
>
> I think the simplest fix would be to add a 'goto' after the assignment
> to iinfo->i_lenAlloc, bypassing the call to udf_extend_file().

Jan is on vacation until early August, so I submitted my own patch:

Date: Mon, 23 Jul 2012 17:39:29 +0100
Subject: [PATCH] udf: fix udf_setsize() for file data in ICB
Message-ID: <1343061569-3629-1-git-send-email-abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


