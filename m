Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2CGG3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:29:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62211 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2CGG3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:29:47 -0500
MIME-Version: 1.0
In-Reply-To: <CABhMZUWDngY6jL8jkxQ+SHzEHqTS4i3DqtCD7DUBtL4QS58ovA@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-24-git-send-email-yinghai@kernel.org>
	<CAErSpo5TjhNv1W=PxSPO6qXfhW1Mi4dMp83vj82=O_hFOq1vow@mail.gmail.com>
	<CAE9FiQXsY7Dn5TGtD1ARM_KFdz1V1hJOvYAy6e4msM=i3VfhDg@mail.gmail.com>
	<CABhMZUWDngY6jL8jkxQ+SHzEHqTS4i3DqtCD7DUBtL4QS58ovA@mail.gmail.com>
Date: Tue, 6 Mar 2012 22:29:46 -0800
X-Google-Sender-Auth: jIRF7J_Lftmy6LwJZdWzGT5zueg
Message-ID: <CAE9FiQV23maKVMrk7h1cJxYfxrqJcKu7GfwFYUJfSDfh8g-KFQ@mail.gmail.com>
Subject: Re: [PATCH 23/23] x86, PCI: add pcibios_root_rescan
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bjorn.helgaas@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 7:49 PM, Bjorn Helgaas <bjorn.helgaas@gmail.com> wrote:

>> my sandbridge system has cpu bus 0x7f, and 0xff in DSDT.
>>
>> but nehalem and westmere system does not have cpu bus 0xf8, ... 0xff.
>
> I think you're saying that on some machines, the BIOS decided not to
> expose host bridges leading to CPU devices, and you want to discover
> those devices anyway.  (What's the reason you want to discover them?)

current code for mmconf will set pcibios_last_bios according to mmconf
bus range.

so it legacy peer root bus fix up will discover those cpu buses.

then if some one remove them through
echo 1 > /sys/devices/pci0000:ff/pci_bus/0000:ff/remove

then

echo 1 > /sys/bus/pci/rescan_root

will not recover those cpu buses without this patch.

Yinghai
