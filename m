Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0FIMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:25:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:52380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab0FIMZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:25:56 -0400
Message-ID: <4C0F87E8.8020405@kernel.org>
Date: Wed, 09 Jun 2010 14:24:08 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Vivek Mahajan <vivek.mahajan@freescale.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] sata_sil24: memset() overflow
References: <20100609120153.GF5483@bicker>
In-Reply-To: <20100609120153.GF5483@bicker>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 12:24:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 02:01 PM, Dan Carpenter wrote:
> cb->atapi.cdb is an array of 16 u8 elements.  The call too memset() 
> would set the first part of the sge array to zero as well.  It's not
> a packed struct. 
> 
> This one has been around for five years.  I found it with Smatch.  I
> think the reason no one has seen it before is because we normally call
> sil24_fill_sg() and that overwrites sge with proper information?

Yeah, the table is built after the memset so it doesn't really break
anything but still where did that 32 come from?  :-)

> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
