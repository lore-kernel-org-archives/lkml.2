Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2BHPiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:38:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab2BHPiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:38:51 -0500
Date: Wed, 8 Feb 2012 16:32:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 3/6] staging: android/lowmemorykiller: Don't grab
	tasklist_lock
Message-ID: <20120208153216.GB15782@redhat.com>
References: <20120203163056.GA4190@redhat.com> <20120206162941.GC5117@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206162941.GC5117@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06, Anton Vorontsov wrote:
>
> Grabbing tasklist_lock has its disadvantages, i.e. it blocks
> process creation and destruction. If there are lots of processes,
> blocking doesn't sound as a great idea.
>
> For LMK, it is sufficient to surround tasks list traverse with
> rcu_read_{,un}lock().
>
> From now on using force_sig() is not safe, as it can race with an
> already exiting task, so we use send_sig() now. As a downside, it
> won't kill PID namespace init processes, but that's not what we
> want anyway.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

