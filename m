Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab2GWPTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:19:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49585 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab2GWPTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:19:41 -0400
Message-ID: <500D6B87.7070700@mev.co.uk>
Date: Mon, 23 Jul 2012 16:19:35 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>
Subject: Bug in UDF, setting larger file size when data in ICB
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

in fs/udf/inode.c, udf_setsize(), if the new size is larger than the old 
size and the old data is in the ICB and the new size still fits in the 
ICB (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB and iinfo->i_lenAlloc 
= newsize), udf_extend_file() is called which promptly calls BUG() 
because it does not like this i_alloc_type value.

I think the simplest fix would be to add a 'goto' after the assignment 
to iinfo->i_lenAlloc, bypassing the call to udf_extend_file().

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
