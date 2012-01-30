Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2A3DYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:24:19 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38109 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2A3DYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:24:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
References: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
Date: Sun, 29 Jan 2012 19:26:55 -0800
In-Reply-To: <20120130011323.GA30274@oksana.dev.rtsoft.ru> (Anton Vorontsov's
	message of "Mon, 30 Jan 2012 05:13:23 +0400")
Message-ID: <m1boplkgzk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/0hxAU3YMAn5jAPSijEYvqiEvANvbJyO8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov <anton.vorontsov@linaro.org> writes:

> We'd like to use this function in the android low memory killer driver, so
> let's export it.
>
> Also, move next_tgid() to kernel/pid.c, so now it lives with the rest of
> pid library functions and does not depend on procfs. Plus, we may now hide
> find_ge_pid() from the global namespace.
>
> While at it, also turn next_tgid()'s comments into kerneldoc format.
>
> There should be no functional changes.

Ouch no.

There is find_ge_pid that is general purpose, and there are a lot of
things with the task list.  But this iterator is specific to the
implementation of proc especially in how it grabs and drops locks.

Using this code outside of /proc will make /proc harder to maintain than
it already is.

Why in the world would you want to traverse processes by pids when
there are well defined iterators for looping over tasks already.

Eric
