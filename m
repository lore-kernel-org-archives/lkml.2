Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab2EKMi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:38:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55707 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491Ab2EKMiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:38:54 -0400
MIME-Version: 1.0
In-Reply-To: <4FAD0304.5060200@broadcom.com>
References: <4FACF02B.7070006@broadcom.com> <CAPXgP12qaNm1Vh=8isf2gq=sUW8hOgi_STNfTuOqg5XT4KgwZA@mail.gmail.com>
 <4FAD0304.5060200@broadcom.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 11 May 2012 14:38:33 +0200
Message-ID: <CAPXgP11CQNeonO6hO7VXq7M9YDDsoPxcCnLm0OU1Xqr1TeVeGw@mail.gmail.com>
Subject: Re: in-kernel drivers and firmware loader
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 2:16 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/11/2012 01:03 PM, Kay Sievers wrote:

>> It's probably sent, but nothing see it because there is no userspace
>> that would have subscribed.
>>
>> If udev is started later during bootup, and the coldplug triggers all
>> events again, the firmware request should be found and be fulfilled by
>> userspace -- at least that's the theory.
>>
>> Can you reach the box with a login before the 60 seconds are reached?
>>
>> Do you see a firmware request (directory) still hanging around in
>> /sys/class/firmware/ ?

> # cd /sys/class/firmware/mmc1\:0001\:2/
> # ls
> data       device     loading    power      subsystem  uevent
> # cat uevent
> FIRMWARE=brcm/brcmfmac-sdio.bin
> TIMEOUT=60
> ASYNC=1
> # cat loading
> 0
>
> Not sure if loading content means anything or it presence is indicating
> it is in progress. Below also the dmesg output.

Yeah, that looks good. The request is still around and waits for
userspace to get handled.

> [   11.448059] smsc95xx 1-1.1:1.0: eth0: link up, 100Mbps, full-duplex,
> [   67.573059] brcmfmac: brcmf_sdbrcm_fw_callback: enter

Seems userspace is not doing anything here, it's just the kernel
timeout that we run into.

If you can manage to do this before the timeout triggers, it should
show if things *can* work:

Start:
  udevd --daemon
if it's not already running.

Trigger 'fake' events for all devices in the system, so that udev
'thinks' the firmware request just came in:
  udevadm trigger --action=add

Normally, all that should be handled by the base system, and not need
any custom setup.

Kay
