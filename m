Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0KJR2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:28:15 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:38361 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab0KJR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:28:14 -0500
Message-ID: <4CDAD4D4.3070009@collabora.co.uk>
Date: Wed, 10 Nov 2010 17:22:28 +0000
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: QEMU Developers <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtualization@lists.osdl.org, Alon Levy <alevy@redhat.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <1097264455.965471288612409433.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>	<4CCEC090.3050009@codemonkey.ws>	<4CD1A406.3090909@collabora.co.uk> <4CD1A73B.2010406@codemonkey.ws> <4CD44759.5020500@collabora.co.uk>
In-Reply-To: <4CD44759.5020500@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping ?

On 05/11/10 18:05, Ian Molton wrote:
> On 03/11/10 18:17, Anthony Liguori wrote:
>> On 11/03/2010 01:03 PM, Ian Molton wrote:
>
>> Why is it better than using virtio-serial?
>
> For one thing, it enforces the PID in kernel so the guests processes
> cant screw each other over by forging the PID passed to qemu.
>
>>> My current patch touches a tiny part of the qemu sources. It works
>>> today.
>>
>> But it's not at all mergable in the current form. If you want to do the
>> work of getting it into a mergable state (cleaning up the coding style,
>> moving it to hw/, etc.) than I'm willing to consider it. But I don't
>> think a custom virtio transport is the right thing to do here.
>
> Hm, I thought I'd indented everything in qemus odd way... Is there a
> codingstyle document or a checkpatch-like tool for qemu?
>
> I'm happy to make the code meet qemus coding style.
>
>> However, if you want something that Just Works with the least amount of
>> code possible, just split it into a separate process and we can stick it
>> in a contrib/ directory or something.
>
> I dont see what splitting it into a seperate process buys us given we
> still need the virtio-gl driver in order to enforce the PID. The virtio
> driver is probably quite a bit more efficient at marshalling the data
> too, given that it was designed alongside the userspace code.
>
>>>> I
>>>> think we can consider integrating it into QEMU (or at least simplifying
>>>> the execution of the backend) but integrating into QEMU is going to
>>>> require an awful lot of the existing code to be rewritten.
>
> Why? aside from codingstyle, whats massively wrong with it thats going
> to demand a total rewrite?
>
>>>> Keeping it
>>>> separate has the advantage of allowing something to Just Work as an
>>>> interim solution as we wait for proper support in Spice.
>
> Why does keeping it seperate make life easier? qemu is in a git repo.
> when the time comes, if it reall is a total replacement, git-rm will
> nuke it all.
>
>>> I dont know why you think integrating it into qemu is hard? I've
>>> already done it.
>>
>> Adding a file that happens to compile as part of qemu even though it
>> doesn't actually integrate with qemu in any meaningful way is not
>> integrating. That's just build system manipulation.
>
> Uh? Either it compiles and works as part of qemu (which it does) or it
> doesnt. How is that not integrated? I've added it to the configure
> script too.
>
> -Ian
>

