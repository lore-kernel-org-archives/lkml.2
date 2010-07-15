Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab0GOAlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:41:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38440 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab0GOAlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:41:07 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org, Jens Axboe <axboe@kernel.dk>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Randy Dunlap <randy.dunlap@oracle.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Howells <dhowells@redhat.com>, Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
References: <20100709185450.GA29473@kroah.com>
	<20100714163852.b3c09930.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 14 Jul 2010 17:40:27 -0700
In-Reply-To: <20100714163852.b3c09930.akpm@linux-foundation.org> (Andrew Morton's message of "Wed\, 14 Jul 2010 16\:38\:52 -0700")
Message-ID: <m1zkxtinlw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 9 Jul 2010 11:54:50 -0700
> Greg Kroah-Hartman <gregkh@suse.de> wrote:
>
>> This is no longer needed by any userspace tools, so it's safe to
>> remove.
>
> Makes my FC6 test box not boot - can't find /dev/root.  Then when I go
> back to plain old mainline (2.6.35-rc5) and run `make oldconfig', the
> .config change sticks:
>
> @@ -106,8 +106,7 @@
>  CONFIG_LOG_BUF_SHIFT=17
>  CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
>  # CONFIG_CGROUPS is not set
> -CONFIG_SYSFS_DEPRECATED=y
> -CONFIG_SYSFS_DEPRECATED_V2=y
> +# CONFIG_SYSFS_DEPRECATED_V2 is not set
>  CONFIG_RELAY=y
>  CONFIG_NAMESPACES=y
>  # CONFIG_UTS_NS is not set
>
> and the box still won't boot.

The reason FC6 doesn't boot is there is a userspace tool
I believe in the initrd that cares about symlinks when it should
not.

What is more interesting is that currently there is a bug in
2.6.35-rc5 where rmmod <netdriver> modprobe <netdriver> will in fact
fail.  There was an inadvertent regression and no one has noticed or
complained.  I spotted it by code review just a little bit ago and I
haven't had a chance to write and test the fix yet.

If the code is going to start bitrotting and no one is going to
notice or care simply removing the code instead of subjecting users
to weird unexpected breakage seems like a responsible thing to do.

Eric
