Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2AEACO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:02:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36510 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab2AEACM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:02:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120105104835.fd6c0fd173622af59d11012f@canb.auug.org.au>
References: <20111228174518.721624fad9d048f9f85b3d50@canb.auug.org.au>
 <20120104230720.GD24583@kroah.com> <20120105104835.fd6c0fd173622af59d11012f@canb.auug.org.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 5 Jan 2012 01:01:51 +0100
Message-ID: <CAPXgP13TC4iuy=MW-p8x05VG8ad-9rC+jxm6qHtx90tBX9zhTw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 00:48, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Kay, Greg, any hints would be nice.  The tip tree commit is adding this:
>
> bool cpu_is_hotpluggable(unsigned cpu)
> {
>        struct sys_device *dev = get_cpu_sysdev(cpu);
>        return dev && container_of(dev, struct cpu, sysdev)->hotpluggable;
> }
>
> and, of course, all the sys_device stuff has now gone ...
>
> So is this correct?
>
> bool cpu_is_hotpluggable(unsigned cpu)
> {
>        struct device *dev = get_cpu_device(cpu);
>        return dev && container_of(dev, struct cpu, dev)->hotpluggable;
> }

Yes, that look like the right pattern.

Stephen, thanks a lot for your help here, it's very much appreciated.
I know we cause a lot of trouble every other year. :)

Thanks,
Kay
