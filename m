Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2A3Ut0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:49:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52910 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2A3UtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:49:25 -0500
Date: Tue, 31 Jan 2012 00:49:20 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
Message-ID: <20120130204920.GA27812@oksana.dev.rtsoft.ru>
References: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
 <20120130134312.GA14110@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120130134312.GA14110@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 02:43:12PM +0100, Oleg Nesterov wrote:
> On 01/30, Anton Vorontsov wrote:
> >
> > We'd like to use this function in the android low memory killer driver, so
> > let's export it.
> 
> I guess you mean 3/3.
> 
> If lowmem_shrink() can use next_tid() which is not really accurate,
> then why tou can't simply change it to use rcu_read_lock ?

Yes, in LMK driver we don't need to be accurate. I probably could use
rcu_read_lock, but the plan was in not holding any global locks (in
this case the rcu) at all, instead I'd like to hold just a reference
of the task, which the driver is analyzing at this time. Once we decide
(to kill or not to kill the task), we either send a signal (and drop
the reference) or just drop the reference.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
