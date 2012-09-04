Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2IDGHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 02:07:45 -0400
Received: from 0106ds1-hvi.0.fullrate.dk ([90.184.84.98]:24276 "EHLO
	mail.knielsen-hq.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2IDGH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 02:07:29 -0400
From: Kristian Nielsen <knielsen@knielsen-hq.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ext3/4] PROBLEM: fdatasync not syncing appended data (w/test program)
References: <87k3wb8pgk.fsf@frigg.knielsen-hq.org>
	<20120903135756.GI21109@quack.suse.cz>
Date: Tue, 04 Sep 2012 08:07:25 +0200
In-Reply-To: <20120903135756.GI21109@quack.suse.cz> (Jan Kara's message of
	"Mon, 3 Sep 2012 15:57:56 +0200")
Message-ID: <87mx165nj6.fsf@frigg.knielsen-hq.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Mon 03-09-12 10:45:15, Kristian Nielsen wrote:
>> It appears that ext3 and ext4 fdatasync() does not fully sync data to
>> disk. Specifically, when new data is written at the end (so that the file
>> length is increased), not all of the new data is synced by fdatasync().

> The culprit is that we forget to update i_datasync_tid when we change only
> inode size. Thus inode is not forced to disk during fdatasync(). I will send
> fixes for this in a moment.

Cool, thanks for the quick response! Glad that we get this fixed.

 - Kristian.
