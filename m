Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2LXU7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 15:59:31 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:34555 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab2LXU72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 15:59:28 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2012 15:59:28 EST
MIME-Version: 1.0
In-Reply-To: <1356336807-5517-1-git-send-email-avagin@openvz.org>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 24 Dec 2012 21:51:10 +0100
X-Google-Sender-Auth: FbY9NsbKK2d75b4ef8yObdfgTnE
Message-ID: <CAHO5Pa0B9KsU-kr=M78kRG5WqOf-ere6YmZ0GPUv4WLF6at_RQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] signalfd: a kernel interface for dumping/restoring
 pending signals
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC+=linux-api]

Hi Andrey,

On Mon, Dec 24, 2012 at 9:13 AM, Andrey Vagin <avagin@openvz.org> wrote:
> The idea is simple. We need to get the siginfo for each signal on dump,
> and then return it back on restore.
>
> The first problem is that the kernel doesn’t report complete siginfo-s
> in user-space. In a signal handler the kernel strips SI_CODE from
> siginfo. When a siginfo is received from signalfd, it has a different
> format with fixed sizes of fields. The interface of signalfd was
> extended. If a signalfd is created with the flag SFD_RAW, it returns
> siginfo in a raw format. We need to choose a queue, so two flags
> SFD_GROUP and SFD_PRIVATE were added.
>
> rt_sigqueueinfo looks suitable for restoring signals, but it can’t send
> siginfo with a positive si_code, because these codes are reserved for
> the kernel. In the real world each person has right to do anything with
> himself, so I think a process should able to send any siginfo to itself.

I see that you CCed me on a couple of the patches in this series.
Thanks for that. But, since most of the series concerns API changes,
it would be good also to CC linux-api on (future revisions of) the
entire series.

I have a few largely cosmetic comments on some of the patches, which
I'll add in the respective threads.

Thanks,

Michael


> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> CC: Cyrill Gorcunov <gorcunov@openvz.org>
>
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
