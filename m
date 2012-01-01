Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab2AAGPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 01:15:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50574 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2AAGPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 01:15:42 -0500
Date: Sat, 31 Dec 2011 22:15:32 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Ted Ts'o" <tytso@mit.edu>,
        "Steinar H. Gunderson" <sgunderson@bigfoot.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 3.2.0-rc5 oops in ext4
In-Reply-To: <20120101042345.GA22312@thunk.org>
Message-ID: <alpine.LSU.2.00.1112312210380.18397@eggly.anvils>
References: <20120101024754.GA14376@uio.no> <20120101042345.GA22312@thunk.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Dec 2011, Ted Ts'o wrote:
> On Sun, Jan 01, 2012 at 03:47:58AM +0100, Steinar H. Gunderson wrote:
> > Hi,
> > 
> > During relatively heavy write load, my 3.2.0-rc5 kernel oopsed (after sixteen
> > days of uptime, so this is not easily reproducible):
> 
> This wasn't the whole kernel oops message.  Can you get any lines
> earlier than this?  (Preferably beginning wit
>  "-----[ cut here ]-----"?)

Nah, not necessary:

RIP: 0010:[<ffffffff81355161>]  [<ffffffff81355161>] _raw_spin_lock+0x9/0x20
[<ffffffff8110d19e>] create_empty_buffers+0x43/0xae
[<ffffffffa030c003>] ext4_discard_partial_page_buffers_no_lock+0x9d/0x3ee [ext4]
[<ffffffffa030c60f>] ext4_da_write_end+0x231/0x2df [ext4]

is one of the symptoms I was seeing - fixed in -rc6 by Yongqiang's
093e6e3666f47d29763a235b404c84ee47ba8bb0
ext4: correctly handle pages w/o buffers in ext4_discard_partial_buffers()

Hugh
