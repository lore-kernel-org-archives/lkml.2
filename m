Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab1GRAFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 20:05:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49826 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab1GRAFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 20:05:49 -0400
Message-ID: <4E237893.70801@zytor.com>
Date: Sun, 17 Jul 2011 17:04:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: Mike Waychison <mikew@google.com>, "Andrew G. Morgan" <agm@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Klibc mailing list <klibc@zytor.com>
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
References: <1310675693-9204-1-git-send-email-mikew@google.com>	<1310675693-9204-2-git-send-email-mikew@google.com>	<20110714234248.7ed43534@lxorguk.ukuu.org.uk>	<CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com>	<20110715000037.3fc1670a@lxorguk.ukuu.org.uk>	<CAGTjWtA5qobWAZb=SbM1y5SFtDKPuJVuAsbDKmkaxxL7mA6OKg@mail.gmail.com>	<20110715003912.149dcedd@lxorguk.ukuu.org.uk>	<CAGTjWtD+5cZxQiE+tikUyz2SNgm3bR95GE2veevEv15cPX1E9A@mail.gmail.com>	<CAGTjWtAo8dE4ASWYPZ0QJdNg3jFzpO=QP4eT5P3mNakxKy-5+g@mail.gmail.com>	<4E20839A.8060200@zytor.com>	<CABV1ukEF_VY-X5ZmBLoiCgNXg_KM06Y7duQQ-qyE0wdEc+eEJw@mail.gmail.com>	<CAGTjWtBUavDUMFoFAFGrUQ700U7YDUBQL_w5rezOsLhp3fjGzw@mail.gmail.com> <CACLa4pspu7YifZXshstyVjeAATQud0PvwbgQPA7kk8zZETMgEA@mail.gmail.com>
In-Reply-To: <CACLa4pspu7YifZXshstyVjeAATQud0PvwbgQPA7kk8zZETMgEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2011 04:19 PM, Eric Paris wrote:
> On Sat, Jul 16, 2011 at 12:42 AM, Mike Waychison <mikew@google.com> wrote:
>> On Fri, Jul 15, 2011 at 3:30 PM, Andrew G. Morgan <agm@google.com> wrote:
>>> I'd put it in kinit too.
>>>
>>> I think you may have to think about the call_usermodehelper code, and
>>> you might want to look at dropping CAP_SYS_MODULE too.
>>
>> Looks like usermodehelpers are configurable for both the inheritable
>> set and the bounding set via /proc/sys/kernel/usermodehelper/bset and
>> /proc/sys/kernel/usermodehelper/inheritable thanks to Eric Paris
>> (17f60a7da, available in 3.0-rc1).
> 
> If you look in Fedora and RHEL you'll see that we actually already
> provide a dracut module (dracut-caps) which can be used to create an
> initrd which contains all of the modules you need to load, it loads
> them, and then will drop all of the caps that you want to drop.   Good
> to see we already solved this problem once!!  (although it requires
> that your kernel and initrd not be in a place that your root user can
> modify it, easy to do in the virt space, no so easy in the real
> hardware world)
> 

Have you considered separating out the kernel-specific portions into a
separate initramfs file (preferrably one which could be built from a
kernel build tree).  The whole dependency of kernels with initramfs is a
huge pain for kernel development and debugging...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

