Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1GaWdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:33:54 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10615 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1GaWdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:33:47 -0400
Date: Mon, 1 Aug 2011 00:33:45 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix leak in
 drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()
In-Reply-To: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1108010032410.28695@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Jesper Juhl wrote:

> We leak memory if the allocations for 'new_param->name' or 'new_param->value' fail.
> We also do a lot of variable assignments that are completely pointless
> if the allocations fail.
> So, let's move the allocations before the assignments and also make
> sure that we free whatever was allocated to one if the allocation for
> another fails.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---

Forgot to mention that I changed the kzalloc's to kmalloc since we 
overwrite all the allocaed memory anyway, so asking for zeroed memory is 
just pointless extra work..

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

