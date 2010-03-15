Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937049Ab0COWsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:48:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:37085 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937016Ab0COWsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:48:36 -0400
Subject: Re: [patch] dpt_i20: several use after free issues
From: James Bottomley <James.Bottomley@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <error27@gmail.com>,
       Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       Yang Hongyang <yanghy@cn.fujitsu.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20100315134526.0b2e3637.akpm@linux-foundation.org>
References: <20100315082656.GJ18181@bicker>
	 <20100315134526.0b2e3637.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 17:48:11 -0500
Message-ID: <1268693291.2853.60.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 13:45 -0700, Andrew Morton wrote:
> On Mon, 15 Mar 2010 11:26:56 +0300
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > adpt_i2o_delete_hba() calls kfree() so we have to save "pHba->next"
> > before calling it.  Also inside adpt_i2o_delete_hba() itself, there
> > was another use after free bug which I fixed by moving the kfree() 
> > down a line.
> 
> erk.  This code should be crashing most gruesomely.  I wonder why it
> doesn't.

I'm tempted to say because we have no users, but actually, for this
driver, I know we do.  So I think it works because most people don't
have poisoning turned on in a running system and there's no sleep
between the free and the use, so no opportunity to reuse the area on the
percpu hot list even in an smp system.

I'll add it to -rc fixes ... when I get the current misc tree broken
apart.

James


