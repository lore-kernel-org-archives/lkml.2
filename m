Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1HLSHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 14:07:41 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10428 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1HLSHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 14:07:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bfpPX+c2jhAErlUGPhag7XWFGUCt7PTLEMhlJMppjqP7o+iiJY5r7+dKjJitHYHLh
	3UhBCV888DAGXGk9PsoOg==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1108121443200.26481@boston.corp.fedex.com>
References: <Pine.LNX.4.64.1108121443200.26481@boston.corp.fedex.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 12 Aug 2011 12:07:16 -0600
Message-ID: <CAErSpo5B=AdnmrvE4uFZN88=erW-CDnw6qO1cMA7Yw3TxiDLdg@mail.gmail.com>
Subject: Re: How to access serial port that is set in BIOS as OS Controlled
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Andrey Panin <pazke@centrinvest.ru>, lkml <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 1:01 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>
> On Fri, Aug 12, 2011 at 5:49 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>> Oops, my mistake.  You now need "pnp.debug=1" to turn the extra debug
>
> Now, I do see more messages and "resources" show "active" ...
>
>
> # dmesg
> pnp 00:00: parse allocated resources
> pnp 00:01: parse allocated resources
> pnp 00:01: PNP0c02: calling 0xc11c8a0c
> pnp 00:02: parse allocated resources
> pnp 00:02: PNP0c02: calling 0xc11c8a0c
> pnp 00:03: parse allocated resources
> pnp 00:04: parse allocated resources
> pnp 00:05: parse allocated resources
> pnp 00:06: parse allocated resources
> pnp 00:07: parse allocated resources
> pnp 00:08: parse resource options
> pnp 00:08:   dependent set 0 (acceptable) io  min 0x3f8 max 0x3f8 align 1
> size 8 flags 0x1
> pnp 00:08:   dependent set 0 (acceptable) irq 4 flags 0x1
> pnp 00:08: parse allocated resources
> pnp 00:08: set resources
> pnp 00:09: parse resource options
> pnp 00:09:   dependent set 0 (acceptable) io  min 0x2f8 max 0x2f8 align 1
> size 8 flags 0x1
> pnp 00:09:   dependent set 0 (acceptable) irq 3 flags 0x1
> pnp 00:09: parse allocated resources
> pnp 00:09: set resources
> pnp 00:0a: parse resource options
> pnp 00:0a:   dependent set 0 (acceptable) io  min 0x3e8 max 0x3e8 align pnp
> 00:0a:   dependent set 0 (acceptable) irq 6 flags 0x1
> pnp 00:0a: pnp_assign_resources, try dependent set 0
> pnp 00:0a: pnp_assign_resources succeeded: current resources:
> pnp 00:0a: [io  0x03e8-0x03ef flags 0x40000101]
> pnp 00:0a:   dependent set 0 (acceptable) irq 6 flags 0x1
> pnp 00:0a: pnp_assign_resources, try dependent set 0
> pnp 00:0a: pnp_assign_resources succeeded: current resources:
> pnp 00:0a: [io  0x03e8-0x03ef flags 0x40000101]
> pnp 00:0a: [irq 6 flags 0x40000401]
> pnp 00:0a: set resources
> pnp 00:0b: parse resource options
> pnp 00:0b:   dependent set 0 (acceptable) io  min 0x2e8 max 0x2e8 align 1
> size 8 flags 0x1
> pnp 00:0b:   dependent set 0 (acceptable) irq 12 flags 0x1
> pnp 00:0b: parse allocated resources
> pnp 00:0b: set resources
> serial 00:0a: pnp_assign_resources, try dependent set 0
> serial 00:0a: pnp_assign_resources succeeded: current resources:
> serial 00:0a: [io  0x03e8-0x03ef flags 0x40000101]
> serial 00:0a: [irq 6 flags 0x40000401]
> serial 00:0a: pnp_start_dev: current resources:
> serial 00:0a: [io  0x03e8-0x03ef flags 0x40000101]
> serial 00:0a: [irq 6 flags 0x40000401]
> serial 00:0a: set resources
> serial 00:0a: encode 2 resources
> serial 00:0a:   encode io 0x3e8-0x3ef decode 0x1
> serial 00:0a:   encode irq 6 edge high exclusive (2-byte descriptor)
>
>
> # cat /sys/bus/pnp/devices/00:0a/resources
> state = active
> io 0x3e8-0x3ef
> irq 6
>
>
> # setserial /dev/ttyS2
> /dev/ttyS2, UART: 16550A, Port: 0x03e8, IRQ: 6
>
>
> # echo activate > /sys/bus/pnp/devices/00:0a/resources
> -bash: echo: write error: Device or resource busy
>
> # dmesg
> serial 00:0a: in use; can't configure
> serial 00:0a: in use; can't configure
>
>
> # echo disable > /sys/bus/pnp/devices/00:0a/resources
> -bash: echo: write error: Device or resource busy
>
> # dmesg
> serial 00:0a: in use; can't configure
> serial 00:0a: in use; can't configure
>
>
>> This *should* work.  My guess is that it's failing because the I/O ports
>> at 0x3e8 are still reserved.  The PNP core doesn't actually reserve
>> anything, so it would have to be the 8250 driver.  It doesn't mention those
>> ports in dmesg, so maybe they get reserved when you do the "setserial."
>
> It's working better now. But, the port is now always active and can't be
> disabled.
>
>
>> The 8250 driver has no idea that you disabled the PNP device, so it would
>> never release them.  Then when you try to activate it again, they're still
>> in use.  You can test this idea a little bit by looking at /proc/ioports (1)
>> immediately after boot, (2) before "setserial", (3) after "setserial", and
>> (4) after you disable the PNP device.
>
> It always shows the same info, except I can't disable the port.
>
> # cat /proc/ioports
>  03e8-03ef : serial

Thanks for testing this.

I think this is all working as expected now.  PNP automatically
configures the port and enables it.  The 8250_pnp driver automatically
claims it.  And I assume the port "just works" without any setserial
or sysfs manipulations at all.  Does that solve your issue?

You can't activate or disable the device via
/sys/bus/pnp/devices/00:0a/resources because a driver (8250_pnp) is
attached to it and PNP won't let you change a device out from under
the driver (this test is in pnp_set_current_resources()).

If you really need to be able to disable the device, you would have to
detach 8250_pnp first, probably using the sysfs unbind file as
described here: http://lwn.net/Articles/143397/.

We need to think a bit more about whether this the right approach for
handling _SRS and whether it's in the right place.  But I think this
is a start, at least.

Bjorn
