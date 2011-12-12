Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1LLVtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:49:47 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61098 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1LLVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:49:45 -0500
Message-ID: <4EE676F2.1020204@gmail.com>
Date: Mon, 12 Dec 2011 16:49:38 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] [PATCH] prctl: Add PR_SET_MM codes to set up mm_struct
 entires v3
References: <20111212200642.836001668@openvz.org> <20111212201715.244414996@openvz.org>
In-Reply-To: <20111212201715.244414996@openvz.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> When we restore a task we need to set up text, data and data
> heap sizes from userspace to the values a task had at
> checkpoint time. This patch adds auxilary prctl codes for that.
> 
> While most of them have a statistical nature (their values
> are involved into calculation of /proc/<pid>/statm output)
> the start_brk and brk values are used to compute an allowed
> size of program data segment expansion. Which means an arbitrary
> changes of this values might be dangerous operation. So to restrict
> access the following requirements applied to prctl calls:
> 
>   - The process has to have CAP_SYS_ADMIN capability granted.

This is very dangerous feature and useless from regular admins.
Moreover, CAP_SYS_ADMIN has a pretty overweight meanings and
we can't disable it on practical. So, I have a question. Why
don't you make new capability for checkpoint?

