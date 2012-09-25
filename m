Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2IYGmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:42:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2IYGmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:42:53 -0400
Message-ID: <50615268.1040805@canonical.com>
Date: Tue, 25 Sep 2012 08:42:48 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
References: <50609C43.1070702@canonical.com> <87txumrct6.fsf@xmission.com>
In-Reply-To: <87txumrct6.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 25-09-12 05:39, Eric W. Biederman schreef:
> Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
>
>> This reverts commit ee3efa91e240f513898050ef305a49a653c8ed90.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>
>> My thread about the regression seemed to have been ignored, so I can only
>> conclude nobody objects against a full revert of this patch.
>>
>> My testcase is simply booting through netboot with / and ~/nfs as separate
>> nfs filesystems, then doing 'ls ~/nfs' followed by 'ls ~' in a gnome-terminal
>> window, then I get:
> Do I read your description correctly:  Without using a bind mount you
> have the same nfs filesystem mounted on / and on ~/nfs?
>
> Something is definitely off with your configuration but if to work you
> need to move mount points around then that something seems much deeper
> than the __d_unalias change.
>
> What filesystems do you have mounted where?
>
/ is a nfs filesystem, ~/nfs is a different nfs filesystem. Just doing ls / is enough
to make all filesystems mounted on / return -EBUSY and disappear.

I also have a subdir of ~/nfs/ bind mounted to /lib/modules/$(uname -r)/kernel
for easy debugging so just doing 'make' in the kernel tree is enough to get the
new modules + bzImage, but I don't know if it is a factor in reproducing this bug
or not.

~Maarten
