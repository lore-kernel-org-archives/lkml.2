Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1CGUgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:36:54 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56732 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab1CGUgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:36:53 -0500
Message-ID: <4D7541E4.1000502@kernel.dk>
Date: Mon, 07 Mar 2011 21:36:52 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Justin TerAvest <teravest@google.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com> <20110301142002.GB25699@redhat.com> <4D6F0ED0.80804@kernel.dk> <AANLkTin+TycqQxWGyxWOsuT+WOaEA0XhqFkJBMKe7-uY@mail.gmail.com> <4D753488.6090808@kernel.dk> <20110307202432.GH9540@redhat.com> <20110307203420.GJ9540@redhat.com>
In-Reply-To: <20110307203420.GJ9540@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 21:34, Vivek Goyal wrote:
> One side affect of limitless bio queueing is an AIO process can queue
> up lots of bios in a group and if one tries to kill the process, it
> waits for all the IOs to finish and can take up a very long time
> depending on throttling limits of the group.

But I doubt this is a problem, really. Sure you could queue tons of IO
with aio if you really wanted, but aio does maintain er per-system
limit. So it's not infinite. The fact that waiting for pending aios can
take a while if you ctrl-c or kill the process is not a real worry,
imho.

-- 
Jens Axboe

