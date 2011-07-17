Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab1GQXTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:19:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32790 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab1GQXTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:19:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAGTjWtBUavDUMFoFAFGrUQ700U7YDUBQL_w5rezOsLhp3fjGzw@mail.gmail.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
	<1310675693-9204-2-git-send-email-mikew@google.com>
	<20110714234248.7ed43534@lxorguk.ukuu.org.uk>
	<CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com>
	<20110715000037.3fc1670a@lxorguk.ukuu.org.uk>
	<CAGTjWtA5qobWAZb=SbM1y5SFtDKPuJVuAsbDKmkaxxL7mA6OKg@mail.gmail.com>
	<20110715003912.149dcedd@lxorguk.ukuu.org.uk>
	<CAGTjWtD+5cZxQiE+tikUyz2SNgm3bR95GE2veevEv15cPX1E9A@mail.gmail.com>
	<CAGTjWtAo8dE4ASWYPZ0QJdNg3jFzpO=QP4eT5P3mNakxKy-5+g@mail.gmail.com>
	<4E20839A.8060200@zytor.com>
	<CABV1ukEF_VY-X5ZmBLoiCgNXg_KM06Y7duQQ-qyE0wdEc+eEJw@mail.gmail.com>
	<CAGTjWtBUavDUMFoFAFGrUQ700U7YDUBQL_w5rezOsLhp3fjGzw@mail.gmail.com>
Date: Mon, 18 Jul 2011 01:19:05 +0200
Message-ID: <CACLa4pspu7YifZXshstyVjeAATQud0PvwbgQPA7kk8zZETMgEA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
From: Eric Paris <eparis@parisplace.org>
To: Mike Waychison <mikew@google.com>
Cc: "Andrew G. Morgan" <agm@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Klibc mailing list <klibc@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 12:42 AM, Mike Waychison <mikew@google.com> wrote:
> On Fri, Jul 15, 2011 at 3:30 PM, Andrew G. Morgan <agm@google.com> wrote:
>> I'd put it in kinit too.
>>
>> I think you may have to think about the call_usermodehelper code, and
>> you might want to look at dropping CAP_SYS_MODULE too.
>
> Looks like usermodehelpers are configurable for both the inheritable
> set and the bounding set via /proc/sys/kernel/usermodehelper/bset and
> /proc/sys/kernel/usermodehelper/inheritable thanks to Eric Paris
> (17f60a7da, available in 3.0-rc1).

If you look in Fedora and RHEL you'll see that we actually already
provide a dracut module (dracut-caps) which can be used to create an
initrd which contains all of the modules you need to load, it loads
them, and then will drop all of the caps that you want to drop.   Good
to see we already solved this problem once!!  (although it requires
that your kernel and initrd not be in a place that your root user can
modify it, easy to do in the virt space, no so easy in the real
hardware world)

-Eric
