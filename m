Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1KGWTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:19:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56801 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1KGWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:19:36 -0500
Message-ID: <4EB85969.2010108@codemonkey.ws>
Date: Mon, 07 Nov 2011 16:19:21 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: "Ted Ts'o" <tytso@mit.edu>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
References: <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>	<4EB6BAED.2030400@redhat.com>	<4EB6BEFA.6000303@codemonkey.ws>	<20111106183132.GA4500@thunk.org>	<CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>	<CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>	<20111106231953.GD4500@thunk.org>	<alpine.LFD.2.02.1111070838520.1823@tux.localdomain>	<alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>	<CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>	<20111107203255.GF24234@thunk.org> <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
In-Reply-To: <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 03:36 PM, Pekka Enberg wrote:
> Hi Ted,
>
> On Mon, Nov 7, 2011 at 10:32 PM, Ted Ts'o<tytso@mit.edu>  wrote:
>> Personally, I consider code that runs in userspace as a pretty bright
>> line, as being "not kernel code", and while perhaps things like
>> initramfs and the crazy ideas people have had in the past of moving
>> stuff out of kernel/init.c into userspace might have qualified as
>> stuff really close to the kernel, something like kvm-tool that runs
>> way after boot, doesn't even come close.  Wine is another example of
>> another package that has lots of close kernel ties, but was also not
>> bundled into the kernel.
>
> It's not as clear line as you make it out to be.
>
> KVM tool also has mini-BIOS code that runs in guest space. It has a
> code that runs in userspace but is effectively a simple bootloader. So
> it definitely doesn't fit the simple definition of "running way after
> boot" (we're _booting_ the kernel too).
>
> Linsched fits your definition but is clearly worth integrating to the
> kernel tree. While you are suggesting that maybe we should move Perf
> out of the tree now that it's mature, I'm pretty sure you'd agree that
> it probably would not have happened if the userspace parts were
> developed out of tree.
>
> There's also spectacular failures in the kernel history where the
> userspace split was enforced. For example, userspace suspend didn't
> turn out the way people envisioned it at the time. We don't know how
> it would have worked out if the userspace components would have been
> in the tree but it certainly would have solved many if the early ABI
> issues.
>
> I guess I'm trying to argue here that there's a middle ground. I'm
> willing to bet projects like klibc and unified initramfs will
> eventually make it to the kernel tree because they simply make so much
> sense. I'm also willing to be that the costs of moving Perf out of the
> tree are simply too high to make it worthwhile.
>
> Does that mean KVM tool should get a free pass in merging? Absolutely
> not. But I do think your position is too extreme and ignores the
> benefits of developing userspace tools in the kernel ecosystem which
> was summed up by Anthony rather well in this thread:
>
> https://lkml.org/lkml/2011/11/7/169

The kernel ecosystem does not have to be limited to linux.git.  There could be a 
process to be a "kernel.org project" for projects that fit a certain set of 
criteria.  These projects could all share the Linux kernel release cadence and 
have a kernel maintainer as a sponsor or something like that.

That is something that could potentially benefit things like e2fs-tools and all 
of the other tools that are tied closely to the kernel.

In fact, having a single place where users could find all of the various kernel 
related tools and helpers would probably be extremely useful.  There's no reason 
this needs to be linux.git though, this could just be a web page on kernel.org.

Regards,

Anthony Liguori

>
>                                  Pekka

