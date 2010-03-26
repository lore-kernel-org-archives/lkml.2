Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0CZKAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 06:00:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab0CZKAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 06:00:51 -0400
Date: Fri, 26 Mar 2010 15:28:21 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, a.p.zijlstra@chello.nl,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Anton Blanchard <anton@samba.org>,
       tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       mingo@elte.hu, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
	hvc_remove
Message-ID: <20100326095821.GA7039@amit-x200.redhat.com>
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-4-git-send-email-gregkh@suse.de> <1269119079.8599.65.camel@pasglop> <20100321043725.GA21566@amit-x200.redhat.com> <20100324121902.GJ15789@amit-x200.redhat.com> <4BAC7AD4.4030309@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAC7AD4.4030309@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) Mar 26 2010 [14:43:56], Sachin Sant wrote:
>> And this suggests that hvc_kick() is called before hvc_task is
>> initialised, ie, before hvc_init() is called.
>>
>> Does this help?
>>   
> Hi Amit,
>
> I too ran into this issue as reported by Anton. Unfortunately in my
> case the following suggested patch does not help boot the powerpc
> box successfully. The boot still hangs with following messages

Was the hang you saw before applying this patch at the same place / for
the same reason?

> /dev/sda5: clean, 229739/2097152 files, 2485598/8377888 blocks (check in 4 mounts)
> fsck succeeded. Mounting root device read-write.
> Mounting root /dev/sda5
> mount -o rw,acl,user_xattr -t ext3 /dev/sda5 /root
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs (sda5): using internal journal
> EXT3-fs (sda5): mounted filesystem with writeback data mode
> mount: can't find /root/proc in /etc/fstab or /etc/mtab
> /sbin/smart_agetty: can not determine 'console' speed

OK, this gets even murkier. I don't know why taking a few krefs modifies
hvc_console behaviour to such an extent.

> Just to confirm i too am facing same issue as reported by Anton,
> reverted commit e74d098c66543d0731de62eb747ccd5b636a6f4c and that allowed
> by box to boot successfully.

Which module uses hvc_console in your case?

		Amit
