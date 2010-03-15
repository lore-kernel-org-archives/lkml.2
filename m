Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936747Ab0COUpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:45:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936715Ab0COUpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:45:47 -0400
Date: Mon, 15 Mar 2010 13:45:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Yang Hongyang <yanghy@cn.fujitsu.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@linux.intel.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] dpt_i20: several use after free issues
Message-Id: <20100315134526.0b2e3637.akpm@linux-foundation.org>
In-Reply-To: <20100315082656.GJ18181@bicker>
References: <20100315082656.GJ18181@bicker>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 11:26:56 +0300
Dan Carpenter <error27@gmail.com> wrote:

> adpt_i2o_delete_hba() calls kfree() so we have to save "pHba->next"
> before calling it.  Also inside adpt_i2o_delete_hba() itself, there
> was another use after free bug which I fixed by moving the kfree() 
> down a line.

erk.  This code should be crashing most gruesomely.  I wonder why it
doesn't.

