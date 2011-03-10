Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1CJSPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:15:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab1CJSPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:15:45 -0500
Date: Thu, 10 Mar 2011 13:15:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, m-ikeda@ds.jp.nec.com,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org, ryov@valinux.co.jp,
        taka@valinux.co.jp, righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com, nauman@google.com,
        mrubin@google.com
Subject: Re: [RFC] [PATCH 0/6] Provide cgroup isolation for buffered writes.
Message-ID: <20110310181529.GF29464@redhat.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
 <20110309142237.6ab82523.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTimRRAEp75CfyJFxU-5wOYfety6gjq=msZf0Wp8P@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimRRAEp75CfyJFxU-5wOYfety6gjq=msZf0Wp8P@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 10:08:03AM -0800, Justin TerAvest wrote:

[..]
> > I don't like to increase size of page_cgroup but I think you can record
> > information without increasing size of page_cgroup.
> >
> > A) As Andrea did, encode it to pc->flags.
> >   But I'm afraid that there is a racy case because memory cgroup uses some
> >   test_and_set() bits.
> > B) I wonder why the information cannot be recorded in page->private.
> >   When page has buffers, you can record the information to buffer struct.
> >   About swapio (if you take care of), you can record information to bio.
> 
> Hi Kame,
> 
> I'm concerned that by using something like buffer_heads stored in
> page->private, we will only be supported on some filesystems and not
> others. In addition, I'm not sure if all filesystems attach buffer
> heads at the same time; if page->private is modified in the flusher
> thread, we might not be able to determine the thread that dirtied the
> page in the first place.

I think the person who dirtied the page can store the information in
page->private (assuming buffer heads were not generated) and if flusher
thread later ends up generating buffer heads and ends up modifying
page->private, this can be copied in buffer heads?

Thanks
Vivek
