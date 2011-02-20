Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab1BTGP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 01:15:56 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:42879 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab1BTGPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 01:15:55 -0500
Date: Sun, 20 Feb 2011 01:15:52 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: ext4 crash on 2.6.37: NULL ptr in ext4_discard_preallocations
Message-ID: <20110220061552.GB8765@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Mark Lord <kernel@teksavvy.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <4D604620.9060204@teksavvy.com>
 <20110220000550.GA8765@thunk.org>
 <4D609E87.5000903@teksavvy.com>
 <4D60A117.8090604@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D60A117.8090604@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 12:05:27AM -0500, Mark Lord wrote:
> I suppose it must be, as there's no other 0x3c offset in that function.
> Which means it's probably this line that's crashing:
> 
>              BUG_ON(pa->pa_obj_lock != &ei->i_prealloc_lock);
> 
> ...which could only happen if "pa" was NULL there.
> I wonder how that happened ?

Which could only happen if ei->i_prealloc_list were not properly
initialized (i..e, it was still NULL).  Which shouldn't ever
happen...., since all ext4_inodes are initialized in
ext4_alloc_inode().

Hmm, can you replicate the crash?

					- Ted
