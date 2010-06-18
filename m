Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938Ab0FREKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 00:10:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab0FREKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 00:10:03 -0400
Date: Thu, 17 Jun 2010 21:08:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
       yanmin.zhang@intel.com
Subject: Re: [PATCH v3 2/2] tmpfs: Make tmpfs scalable with percpu_counter
 for  used blocks
Message-Id: <20100617210859.40e024a1.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikOpTsdxhjqE0G3oEv9qT2nRFp3y5fjDUqXlw4X@mail.gmail.com>
References: <1276818993.9661.82.camel@schen9-DESK>
	<AANLkTikOpTsdxhjqE0G3oEv9qT2nRFp3y5fjDUqXlw4X@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 10:35:51 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:

> > __struct shmem_sb_info {
> > __ __ __ __unsigned long max_blocks; __ /* How many blocks are allowed */
> > - __ __ __ unsigned long free_blocks; __/* How many are left for allocation */
> > + __ __ __ struct percpu_counter used_blocks; __/* How many are allocated */
> 
> Just a nitpick.
> Why do you change free_blocks and used_blocks?
> I think we can use free_blocks following as.
> 
> ex)
> if (percpu_counter_compare(&sbinfo->free_blocks, 0))

See previous lengthy discussion ;)

If we count free_blocks then we need to alter the value of free_blocks
in remount_fs, and reinitialising distributed counters on-the-fly is
ugly.

I suppose we could have done it by doing a large add or sub in
remount_fs, and keeping track of the exact value of free_blocks
elsewhere in the superblock, but it's far simpler this way.

