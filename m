Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1J0Hpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:45:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46606 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab1J0Hpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:45:45 -0400
MIME-Version: 1.0
In-Reply-To: <1319645292.3321.24.camel@br98xy6r>
References: <1319645292.3321.24.camel@br98xy6r>
Date: Thu, 27 Oct 2011 15:45:44 +0800
Message-ID: <CAM_iQpXHieUhvTHOno_qQmE+6=PPhqrkuA4Xa7HP8JB9buOm=A@mail.gmail.com>
Subject: Re: kdump: No udev events for memory hotplug?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: holzheu@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 12:08 AM, Michael Holzheu
<holzheu@linux.vnet.ibm.com> wrote:
> Hello Vivek and Eric,
>

Hello,

> I noticed that on my system kernel 3.1 *no* udev events for memory
> hotplug are generated. Same on my RHEL6.1.
>
> # udevadm monitor
> # echo offline > /sys/devices/system/memory/memory4/state
>
> -> No event
>
> But we need the udev events in order to do a kdump reload for setting up
> the ELF loads correctly.
>
> In my /etc/udev/rules.d/98-kexec.rules there are rules for memory
> hotplug:
>
> SUBSYSTEM=="memory", ACTION=="add", PROGRAM="/etc/init.d/kdump restart"
> SUBSYSTEM=="memory", ACTION=="remove", PROGRAM="/etc/init.d/kdump
> restart"
>
> Perhaps/probably I am missing something?

As Heiko pointed out, probably the memory-hotplug subsystem doesn't implement
uevent, this is why you can't get uevent when you hot-remove the memory.

For kdump, the memory is reserved by "crashkernel=", it is determined during
boot (but you can shrink it after boot), so it is not aware of memory hotplug.
IOW, if you hot-remove the memory where the crash kernel stays, the
'kdump restart'
will fail. But yes, restarting kdump can rebuild the memmap and ELF headers.

Thanks.
