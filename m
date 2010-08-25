Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab0HYC7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 22:59:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0HYC66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 22:58:58 -0400
Message-ID: <4C7486F4.3080702@ontolinux.com>
Date: Wed, 25 Aug 2010 04:59:01 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Valerie Aurora <vaurora@redhat.com>
CC: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene> <20100817204430.GE5556@shell> <6820.1282094632@jrobl> <20100818185542.GA10850@shell> <16318.1282181699@jrobl> <20100824000505.GA20909@shell> <6881.1282616917@jrobl> <20100824204839.GB28718@shell>
In-Reply-To: <20100824204839.GB28718@shell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:2CtK2NxYX7GpIm9kvUoPg4qUxwiMiWTDAHnQ3vydk86
 eJFjCVnfdXWY0WvBLq/iPJVJNYswuMAK90MRx0VpdjHtML49YW
 3Uyk2AmKadu1NM6AmRBjdr/CgO1k7nHJXN7x/q23oM2l5ESucL
 6ruaRlHq2CzYotOm8YYuJK5wrmwutv1HyYJngTq4JOJH4DkBVR
 3YdH+5c0bPesKU526UVrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Aloha Everybody;

On the 24.08.2010 22:48, Valerie Aurora wrote:
> On Tue, Aug 24, 2010 at 11:28:37AM +0900, J. R. Okajima wrote:
>> Thank you for explanation, very much.

Me too

> You are welcome!
>
>> When a rename happens on a layer directly, aufs receives a
>> inotify/fsnotify event. Following the event type, aufs makes the cached
>> dentry/inode obsoleted and they will be lookup-ed again in the
>> succeeding access. Finally aufs will know the upper parent_dir1 is not
>> covering the lower parent_dir2 anymore.
>> This notification is the main purpose of the strict option which is
>> called "udba=notify" (User's Direct Branch Access).
> No, that's not a sufficient description and leaves open questions
> about all sorts of deadlocks and race conditions.  For example,
> inotify events occur while holding locks only on one layer.  You
> obviously need to lock the top layer to update the inheritance and
> parent-child relationships.  Now you are locking the lower layer first
> and the top layer second, which is the reverse of the usual order.
> Also, it should not be an option.
>
> If Al Viro says it's wrong, you need a very detailed explanation of
> why it is right.  See Documentation/filesystem/directory-locking for
> an example of the argument you have to make to show that moving things
> around on the lower layer is safe.  In general, your first task is to
> show a global lock ordering to prove lack of deadlocks (which I don't
> think you should spend time on because most VFS experts think it is
> impossible to do with two read-write layers).

This all reminds me of the 5/dining philosophers problem and its 
solutions, especially the waiter and the resource hierarchy solutions 
(see [1]).
And I do think that such problems can always be solved in a real world 
context, but often the solutions are very time and/or space consuming.

> I'm not going to explain any more how aufs is wrong; it's the
> maintainer's job to convince Al Viro and other maintainers that aufs
> is right.  But I hope this gave you a start and showed why union
> mounts is a preferred approach for many people.
>
> Thanks,
>
> -VAL

[1] http://en.wikipedia.org/wiki/Dining_philosophers_problem

Have fun
Christian
