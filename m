Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1GaWok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:44:40 -0400
Received: from mail.perches.com ([173.55.12.10]:4414 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1GaWoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:44:37 -0400
Subject: Re: [PATCH] Fix leak in
 drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jul 2011 15:44:34 -0700
Message-ID: <1312152274.11635.8.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 00:28 +0200, Jesper Juhl wrote:
> We leak memory if the allocations for 'new_param->name' or 'new_param->value' fail.
> We also do a lot of variable assignments that are completely pointless
> if the allocations fail.
> So, let's move the allocations before the assignments and also make
> sure that we free whatever was allocated to one if the allocation for
> another fails.

> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
[]
> +		new_param->name = kmalloc(strlen(param->name) + 1, GFP_KERNEL);
> +		new_param->value = kmalloc(strlen(param->value) + 1, GFP_KERNEL);
[]
>  		memcpy(new_param->name, param->name, strlen(param->name));
>  		new_param->name[strlen(param->name)] = '\0';
>  		memcpy(new_param->value, param->value, strlen(param->value));

kstrdup

