Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2A3Tul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:50:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55765 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2A3Tuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:50:40 -0500
Date: Mon, 30 Jan 2012 23:50:33 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg KH <gregkh@suse.de>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
Message-ID: <20120130195033.GA1557@oksana.dev.rtsoft.ru>
References: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
 <20120130022242.GA5805@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120130022242.GA5805@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 06:22:42PM -0800, Greg KH wrote:
> On Mon, Jan 30, 2012 at 05:13:23AM +0400, Anton Vorontsov wrote:
> > We'd like to use this function in the android low memory killer driver, so
> > let's export it.
> 
> Why is it needed?
> 
> I _REALLY_ don't want to add any exports to any part of the kernel for
> the android low memory stuff.  That is because it is not something that
> should be touching anything else, especially as numerous people disagree
> with what it does and how it does it.
> 
> Instead, you should be spending the time and effort to properly
> implement this, as has been discussed numerous times, the last one a
> mere few weeks ago when someone tried adding the nokia-specific low
> memory killer/notifier code.

Yep, and I fully agree here. But doing it the right way (i.e. teaching
Android to use low memory notifiers) will take some time. And improving
current driver meanwhile is just my sub-task.

> So no, sorry, I will not take these patches, unless you come up with
> some very good justifications why.

Well, actually, this patches were born as a response to LMK review[1]
by KOSAKI Motohiro, he did not like the tasklist lock. Though, I agree
that it might be not a great idea to export API for the driver that
is about to superseded by a different approach (i.e. notifiers). :-)

Heh. But you never know where you'll end up before you actually
try to do something. I have tried to get rid of the tacklist lock,
and it appears that it causes more trouble. :-)

[1] http://lkml.org/lkml/2011/12/19/294

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
