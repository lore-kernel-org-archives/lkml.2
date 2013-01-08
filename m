Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3AHJpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:45:32 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:60940 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab3AHJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:45:28 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
        viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
        martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
        Zheng Liu <gnehzuil.liu@gmail.com>, linux-kernel@vger.kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
        v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide stable pages during write
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
	<20121213080811.23360.98131.stgit@blackbox.djwong.org>
	<877go3z4ra.fsf@devron.myhome.or.jp>
	<20121227210543.GA20103@blackbox.djwong.org>
	<87y5gjxj2k.fsf@devron.myhome.or.jp>
	<20130107204436.GO20106@blackbox.djwong.org>
Date: Tue, 08 Jan 2013 18:44:57 +0900
In-Reply-To: <20130107204436.GO20106@blackbox.djwong.org> (Darrick J. Wong's
	message of "Mon, 7 Jan 2013 12:44:36 -0800")
Message-ID: <87k3roypnq.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> On Fri, Dec 28, 2012 at 06:48:35AM +0900, OGAWA Hirofumi wrote:
>> "Darrick J. Wong" <darrick.wong@oracle.com> writes:
>> 
>> >> I think this flag should be separated into "FS provide stable page" and
>> >> "FS needs bounce buffer for stable page".
>> >> 
>> >> My fs (I guess btrfs also) provides stable page by better way, and
>> >> doesn't need to wait writeback flags too. What needs is just to avoid
>> >> those stable page stuff.
>> >
>> > How does your fs (are we talking about vfat?) provide stable pages?
>> 
>> Basically it copies the data to another page before modifying data only
>> if page has writeback flag. (this is about new fs under development stage.)
>
> Aha, we're talking about tux3.  Since (afaik) there aren't any other
> filesystems requesting this flag and tux3 uses the device bdi, should I just
> create a patch and send it to you so it'll be included when tux3 goes in?

If core doesn't provide, no need to waste your time. I will.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
