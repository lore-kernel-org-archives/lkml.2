Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1IHCvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 22:51:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52753 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab1IHCvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 22:51:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110905153758.GJ5466@quack.suse.cz>
References: <20110830071407.GA8165@albatross.gern.madduck.net>
	<20110905153758.GJ5466@quack.suse.cz>
Date: Wed, 7 Sep 2011 22:51:43 -0400
Message-ID: <CAPL5yKcRbYEsiZwyiT5aMfcmNUi_gam5Pj_ks_Apj-fE=Lc4KA@mail.gmail.com>
Subject: Re: Abysmal I/O scheduling with dm-crypt
From: Dan Merillat <dan.merillat@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: martin f krafft <madduck@madduck.net>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue 30-08-11 09:14:07, martin f krafft wrote:
>> People not running dm-crypt seem unable to reproduce this problem,
>> making me think that it must be due to dm-crypt, and I wouldn't find
>> it hard to imagine, because dm-crypt basically shields the
>> I/O-scheduler of the kernel, doesn't it? Worse, it probably doesn't
>> make any effort of scheduling I/O itself. Note: I know very little
>> about the internals, so please correct me if I am wrong.

No, it's not specific to dm-crypt, these kinds of annoying IO hangs happen
on bare drives, MD arrays or DM-* setups.

There's a number of causes - including firefox history updates and the
abuse of create/sync/rename due to metadata hitting disk before data.

There's not going to be any movement on that front, I'm afraid, see
"Don't fear the fsync" (reproduced at
http://www.linuxfoundation.org/news-media/blogs/browse/2009/03/don%E2%80%99t-fear-fsync
 , the original site couldn't be reached while I'm writing this).

You can either throw more hardware at it, or use libeatmydata to
disable fsync across the board.  Maybe, eventually, a filesystem will
be written that can manage an atomic replace without fsync().  Don't
hold your breath.
