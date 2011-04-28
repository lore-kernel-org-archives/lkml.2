Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab1D1DVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:21:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56229 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab1D1DVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:21:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 4/7] seccomp_filter: add process state reporting
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org, rostedt@goodmis.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>
In-Reply-To: <1303960136-14298-3-git-send-email-wad@chromium.org>
References: <1303960136-14298-1-git-send-email-wad@chromium.org> <1303960136-14298-3-git-send-email-wad@chromium.org>
Message-Id: <20110428122334.D197.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 28 Apr 2011 12:21:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Adds seccomp and seccomp_filter status reporting to proc.
> /proc/<pid>/status will include a Seccomp field, and
> /proc/<pid>/seccomp_filter will provide read-only access
> to the current filter and bitmask set for seccomp_filters.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  fs/proc/array.c |   21 +++++++++++++++++++++
>  fs/proc/base.c  |   25 +++++++++++++++++++++++++
>  2 files changed, 46 insertions(+), 0 deletions(-)

I'm not againt seccomp_filter. but I dislike to increase /proc/<pid>/status mess.
1) it's read from a lot of applications, I don't want to worry about performance
thing. 2) 99.99% user never use seccomp. this field is useless for them.

Can't you make individual seccomp specific file?



