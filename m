Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2I0PrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:47:08 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55327 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2I0PrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:47:07 -0400
Message-ID: <506474E8.3030300@ahsoftware.de>
Date: Thu, 27 Sep 2012 17:46:48 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
References: <50531629.9020107@ahsoftware.de> <20120925110206.GD28937@mwanda> <50643C4A.9010202@ahsoftware.de> <20120927151232.GA12210@quack.suse.cz>
In-Reply-To: <20120927151232.GA12210@quack.suse.cz>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 27.09.2012 17:12, schrieb Jan Kara:
>    Just some thoughts about your oops:
> The assertion which fails is:
> BUG_ON(!list_empty(&bh->b_assoc_buffers));
>
> Now b_assoc_buffers isn't used very much. In particular ext4 which you seem
> to be using doesn't use this list at all (except when mounted in nojournal
> mode but that doesn't seem to be your case). That would point rather
> strongly at a memory corruption issue.
>
> So if you can reproduce the oops, it might be interesting to print
> bh->b_assoc_buffers.next and &bh->b_assoc_buffers.next if the list is found
> to be non-empty.

Hmm, a loose pointer would explain it all too. Especially the cases when 
I just have seen wrong content in the archive without having any oops. I 
try to reproduce it with

pr_info("AHO: %p %p\n", bh->b_assoc_buffers.next, 
&bh->b_assoc_buffers.next);

after the BUG_ON().

Thanks for the hint. I wasn't already that far to know that 
b_assoc_buffers isn't used that much.

Regards,

Alexander
