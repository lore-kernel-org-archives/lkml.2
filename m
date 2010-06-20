Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0FTO2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 10:28:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46261 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab0FTO2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 10:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OXDAGJc3dvOLt2UU1spoFfiL75NRz3k+fp0+VEYdtNNEIsTDaV1Qcu7qCikXSMLXLT
         HwxzkrcQjPEOqciQbg7LXSxVH/zG0aMddwUI2a3mkpbbrF7jafDUas+XtC9umTiNkb5k
         MED1lUzPEqOVf47dq8p6wAvz+cdyQKH3StH54=
Date: Sun, 20 Jun 2010 23:28:42 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
       yanmin.zhang@intel.com
Subject: Re: [PATCH v3 2/2] tmpfs: Make tmpfs scalable with percpu_counter
 for used blocks
Message-ID: <20100620142842.GA2369@barrios-desktop>
References: <1276818993.9661.82.camel@schen9-DESK>
 <AANLkTikOpTsdxhjqE0G3oEv9qT2nRFp3y5fjDUqXlw4X@mail.gmail.com>
 <20100617210859.40e024a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617210859.40e024a1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 09:08:59PM -0700, Andrew Morton wrote:
> On Fri, 18 Jun 2010 10:35:51 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > > __struct shmem_sb_info {
> > > __ __ __ __unsigned long max_blocks; __ /* How many blocks are allowed */
> > > - __ __ __ unsigned long free_blocks; __/* How many are left for allocation */
> > > + __ __ __ struct percpu_counter used_blocks; __/* How many are allocated */
> > 
> > Just a nitpick.
> > Why do you change free_blocks and used_blocks?
> > I think we can use free_blocks following as.
> > 
> > ex)
> > if (percpu_counter_compare(&sbinfo->free_blocks, 0))
> 
> See previous lengthy discussion ;)
> 
> If we count free_blocks then we need to alter the value of free_blocks
> in remount_fs, and reinitialising distributed counters on-the-fly is
> ugly.
> 
> I suppose we could have done it by doing a large add or sub in
> remount_fs, and keeping track of the exact value of free_blocks
> elsewhere in the superblock, but it's far simpler this way.
> 

Thanks, Andrew. I found your comment in previous mail thread. 
Tim, Please add below Andrew's comment in description. 

It would make reviewer happy in future.

--
Andrew's comment
" It a bit buggy - using percpu_counter_init() against an
already-initialised percpu_counter() is leaky.  I suspect that's
happening in remount_fs.

A better approach would be to remove free_blocks altogether and add a
new `percpu_counter used_blocks;' which simply counts how many blocks
are presently in use.  Such a thing would then never need to be
reinitialised."


-- 
Kind regards,
Minchan Kim
