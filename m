Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab1CIPT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:19:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757097Ab1CIPT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:19:57 -0500
Date: Wed, 9 Mar 2011 10:19:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Justin TerAvest <teravest@google.com>, m-ikeda@ds.jp.nec.com,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org, ryov@valinux.co.jp,
        taka@valinux.co.jp, righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com, nauman@google.com,
        mrubin@google.com
Subject: Re: [RFC] [PATCH 0/6] Provide cgroup isolation for buffered writes.
Message-ID: <20110309151940.GC10346@redhat.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
 <20110309142237.6ab82523.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309142237.6ab82523.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 02:22:37PM +0900, KAMEZAWA Hiroyuki wrote:
[..]

> B) I wonder why the information cannot be recorded in page->private.
>    When page has buffers, you can record the information to buffer struct.
>    About swapio (if you take care of), you can record information to bio.
> 

This sounds very interesting. I am not a vm guy hence I have no idea in
what situations page->private is used and is it ok, to introduce one
more user of it. But if it works, then getting rid of this dependency
on page_cgroup is a huge plug, IMHO.

> Anyway, thank you for the work. And please join the discussion and explain
> "Without it, we didn't see much isolation improvement." with real data.

Agreed. AFAICS, this piece is not going to help much until and unless
we have upper layers fixed (per cgroup dirty ratio and cgroup aware writeout).
So once those two are fixed and in kernel, it will pave the way for
this piece to go in.

Thanks
Vivek
