Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab1E2IHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 04:07:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51871 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1E2IHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 04:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=UteivgAFB0PSd97DLLBMqx4SDY8vlM82JLrY74loxfBpXIJ4m3q377XDwK56oxQxFH
         qVRTMpBH60OhVZTE+5798errLBHIByobr6Ta2Qoh17abrNo897Pp8KzvIKyemImXvo5O
         IkybTFf8ZXrBWRHPLhUZ/bERl+hDKOqCOriSU=
From: Chris Clayton <chris2553@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39 - crash when plugging in a usb memory stick
Date: Sun, 29 May 2011 09:07:01 +0100
User-Agent: KMail/1.9.10
Cc: peter@alfsgard.dk
References: <201105270909.00183.chris2553@googlemail.com>
In-Reply-To: <201105270909.00183.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105290907.01914.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

On Friday 27 May 2011 09:09:00 Chris Clayton wrote:
> Hi,
>
> I've just had the following crash after plugging in a usb memory stick.
> Some diagnostic output may be missing because it was scrolled off screen by
> a subsequent oops, which I have assumed was induced by this crash and not,
> therefore, copied down. Also, I skipped writing down the modules linked
> because it's a long list, but there are no out-of-tree modules of any kind
> and the kernel was not tainted (until after this crash).

Peter Alfredsen seems to be experiencing exactly the same crash. At least
the call trace appears identical.
http://marc.info/?l=linux-kernel&m=130662291207794&w=4

>
> last sysfs file: /sys/devices/virtual/bdi/8:32/uevent
> Modules linked in  ...
> PID: 3, comm: ksoftirqd/0 Not tainted 2.6.39 #1 Gigabyte Techmology Co.,
> Ltd  EG41MF-US2H/EG41MF-US2H EIP is at 0x0
> EAX: f4500e20 EBX:f4500e20 ECX:ebc88c60 EDX: 00000000
> ESI: f4500e20 EDI: c9c9fc00 EBP: ebc2d420 ESP: f4c4be80
> DS: 007b ES: 007b FS: 00d8 GS:0000 SS: 0068
> Process ksoftirqd/0 (pid 3, ti=f4c4a000 task=f4c44720 task.ti=f4c4a000)
> Stack:
>  c114d4ec f4500e20 c9c9fc00 ebc2d420 00000000 f4500e20 c9c9fc00 c120abce
>  c141e188 c120a944 e2d13d9c fffffffb c102582f c6258840 f4500e20 00000296
>  c9c9fc00 e6c2d420 c114ada8 ebc2d400 f4c4beec c12094de cb2580c0 00000246
> Call trace:
> c114d4ec blk_peek_request+oxfc/0x150
> c120abce scsi_request_fn+ox30e.0x370
> c120a944 scsi_request_fn+0x84/0x370
> c102582f complete+0x3f/-x60
> c114ada8 blk_run_queue+0x28/0x40
> c12094de scsi_run_queue+0xae/0x230
> c120aef0 scsi_next_command+0x30/0x50
> c120b0a0 scsi_io_completion+0x150/0x590
> c1151722 blk_done_softirq+0x52/0x60
> c1037f85 __do_soft_irq+0x75/0xf0
> c1075b7f rcu_note_context_switch+0x6f/0x150
> c10380b8 run_softirqd+0xb8/0x1a0
> c1038000 __do_softirq+0xf0/0xf0
> c104b104 kthread+0x74/0x80
> c1048090 kthread_worker_fn+0x170/0x170
> c13623f6 kernel_thread_helper+0x6/0xd
> Code: Bad EIP value
> EIP: [<00000000>] 0x0 SS:ESP 0068:f4c4be80
> CR2: 00000000000000000
>
> I've been using 2.6.39 since the day it was released, plus -rc version
> since rc2 and this is the first crash I have experienced. Consequently,
> recreating the crash might not be possible. Nevertheless, let me know if
> there's any way I can help to fix this.
>
> Chris



-- 
The more I see, the more I know. The more I know, the less I understand. Changing Man - Paul Weller
