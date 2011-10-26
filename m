Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab1JZRbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:31:49 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46886 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885Ab1JZRbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:31:49 -0400
Date: Wed, 26 Oct 2011 13:31:47 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, joe korty <joe.korty@ccur.com>,
        amwang@redhat.com
Subject: Re: [PATCH 7/4] ipc/mqueue: separate mqueue default value from maximum value
Message-ID: <947642e6-3af0-4352-9982-9ae38ccce1c4@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4EA8297B.6020403@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.3.113.99]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> commit b231cca438 (message queues: increase range limits)
> changed mqueue default value when attr parameter is specified NULL
> from hard coded value to fs.mqueue.{msg,msgsize}_max sysctl value.
> 
> This made large side effect. When user need to use two mqueue
> applications 1) using !NULL attr parameter and it require big
> message size and 2) using NULL attr parameter and only need small
> size message, app (1) require to raise fs.mqueue.msgsize_max and
> app (2) consume large memory size even though it doesn't need.
> 
> Doug Ledford propsed to switch back it to static hard coded value.
> However it also has a compatibility problem. Some applications might
> started depend on the default value is tunable.
> 
> The solution is to separate default value from maximum value.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Amerigo Wang <amwang@redhat.com>
> Cc: Serge E. Hallyn <serue@us.ibm.com>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Joe Korty <joe.korty@ccur.com>

Acked-by: Doug Ledford <dledford@redhat.com>

> ---
>  Documentation/sysctl/fs.txt   |    7 +++++++
>  include/linux/ipc_namespace.h |    3 +++
>  ipc/mq_sysctl.c               |   18 ++++++++++++++++++
>  ipc/mqueue.c                  |    9 ++++++---
>  ipc/msgutil.c                 |    2 ++
>  5 files changed, 36 insertions(+), 3 deletions(-)

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

