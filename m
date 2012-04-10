Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab2DJIuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:50:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38473 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2DJIuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:50:15 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <4F7F60BF.9070500@suse.cz>
References: <4F717CE3.4040206@suse.cz>
	<4F717D80.9040207@suse.cz>
	<4F758400.3080907@suse.cz>
	<1333104359_155028@CP5-2952>
	<4F75A303.3030409@suse.cz>
	<1333110296_156038@CP5-2952>
	<4F7F60BF.9070500@suse.cz>
Date: Tue, 10 Apr 2012 10:50:14 +0200
X-Google-Sender-Auth: BbIKT6flw6vQDsAyDI7SmxqHmfk
Message-ID: <CAKMK7uH9WaFD0f3z7EyD61haaa3fWVQxa_OvVicsJXLhrGuF1A@mail.gmail.com>
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared [generic IRQ
 handling broken?]
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Jiri Slaby <jirislaby@gmail.com>,
        Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 23:31, Jiri Slaby <jslaby@suse.cz> wrote:
>> That was introduced in 05eff845a28499762075d3a72e238a31f4d2407c to close
>> a race where the pipestat triggered an interrupt after we processed the
>> secondary registers and before reseting the primary.
>>
>> But the basic premise that we should only enter the interrupt handler
>> with IIR!=0 holds (presuming non-shared interrupt lines such as MSI).
>
> Ok, this behavior is definitely new. I get several "nobody cared" about
> this interrupt a week. This never used to happen. And something weird
> emerges in /proc/interrupts when this happens:
>  42:    1003292    1212890   PCI-MSI-edge      �s����:0000:00:02.0
> instead of
>  42:    1006715    1218472   PCI-MSI-edge      i915@pci:0000:00:02.0

This looks ugly. Can you try to reproduce on 3.4-rc2? That should
contain everything that -next currently contains drm/i915-wise. If it
still happens there, please bisect it.

Also please check whether any of the subordinate interrupt regs
(pipestat) is stuck and might cause these interrupts as Jesse
suggested.

Thanks, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
