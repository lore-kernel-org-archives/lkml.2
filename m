Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2IQQzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:55:40 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39702 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab2IQQzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:55:38 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, viro@zeniv.linux.org.uk, hch@lst.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix queueing work if !bdi_cap_writeback_dirty()
References: <20120914131952.GA4952@quack.suse.cz>
	<87ipbgn2gz.fsf@devron.myhome.or.jp>
	<20120914144543.GB4952@quack.suse.cz>
	<878vccmygy.fsf@devron.myhome.or.jp>
	<20120916214912.GA7503@quack.suse.cz>
	<87wqzt7drb.fsf@devron.myhome.or.jp>
	<20120917084853.GA9150@quack.suse.cz>
	<87627d6lae.fsf@devron.myhome.or.jp>
	<20120917095623.GB9150@quack.suse.cz>
	<87obl55405.fsf@devron.myhome.or.jp>
	<20120917155406.GC9150@quack.suse.cz>
Date: Tue, 18 Sep 2012 01:55:29 +0900
In-Reply-To: <20120917155406.GC9150@quack.suse.cz> (Jan Kara's message of
	"Mon, 17 Sep 2012 17:54:06 +0200")
Message-ID: <87d31k6132.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> Duplicate flusher - many FSes has own task to flush.  Odd behavior in
>> the case of partition - agree, but I'm not sure why metadata is ok, and
>> it is not odd behavior.
>   Well, because there is much more of data pages then there is metadata. So
> when you do strange things (like refuse to write / reclaim) with metadata,
> it usually ends up in the noise. But when you start doing similar things
> with data pages, people will notice.

Could you explain more. So, you are thinking we have to fix current
behavior for metadata intensive applications? And what will people
notice?

>> Sorry, I'm not sure your point in latest comment. You are just saying FS
>> must flush pages on writepages()?
>   Yes.
>
>> And if alternative plan is acceptable, maybe I will not have interest to
>> this anymore.
>   Yes, the alternative plan looks better to me. But all in all I don't want
> to stop you from your experiments :) I mostly just wanted to point out that
> disabling flusher thread for a filesystem has a complex consequences which
> IMHO bring more bad than good.

OK, thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
