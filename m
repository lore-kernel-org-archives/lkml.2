Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2IMMRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:17:46 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:38399 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab2IMMRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:17:42 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
References: <871ui84l4l.fsf@devron.myhome.or.jp>
	<CAKYAXd89CKZa9nV3pBiFgcpGsYzX1-iCB+UJ8bBvst88GnB4mg@mail.gmail.com>
	<20120912143227.GE3009@fieldses.org>
	<87vcfjfa14.fsf@devron.myhome.or.jp>
	<20120912171128.GG3009@fieldses.org>
	<87r4q7f8fw.fsf@devron.myhome.or.jp>
	<20120912174556.GH3009@fieldses.org>
	<87ipbjf54f.fsf@devron.myhome.or.jp>
	<CAKYAXd-5CQrE=232NKk9pRjzP3q8OBryeLt9mH==f=zrKdjzNg@mail.gmail.com>
	<87txv2cog1.fsf@devron.myhome.or.jp>
	<20120913112024.GA24684@fieldses.org>
Date: Thu, 13 Sep 2012 21:17:32 +0900
In-Reply-To: <20120913112024.GA24684@fieldses.org> (J. Bruce Fields's message
	of "Thu, 13 Sep 2012 07:20:25 -0400")
Message-ID: <87ehm6p15v.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

>> >> Grepping around... Documentation/sysctl/vm.txt mentions a
>> >> vfs_cache_pressure parameter.
>> >> Yeah. And dirty hack will be possible to adjust sb->s_shrink.batch.
>> > I am worrying if it could lead to OOM condition on embedded
>> > system(short memory(DRAM) and support 3TB HDD disk of big size.)
>> >
>> > Please let me know if any issues or queries.
>> 
>> So, now I think stable inode number may be useful if there are users of
>> it. And I guess those functionality is no collisions with -mm. And I
>> suppose we can add two modes for "nfs" option (e.g. nfs=1 and nfs=2).
>> 
>> If nfs=1, works like current -mm without no limited operations.
>
> Apologies, I haven't been following the conversation carefully: remind
> me what "works like current -mm" means?

Current -mm means the best-effort work only if inode cache is not
evicted.  I.e. if there is no inode cache anymore on server, server
would return ESTALE. So I guess the behavior would not be stable
relatively.

Thanks.

>> If nfs=2, try to make stable FH and limit some operations
>> 
>> (option name doesn't matter here.)
>> 
>> Does this work fine?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
