Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab2IFRYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:24:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47868 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab2IFRYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:24:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120906090522.GA25102@localhost>
References: <20120905065118.GA9603@localhost>
	<CAE9FiQVO6dj+rEP=phQD5VYEF-rak6UPYGMSV8ud0OyELo7Opg@mail.gmail.com>
	<20120906090522.GA25102@localhost>
Date: Thu, 6 Sep 2012 10:24:43 -0700
X-Google-Sender-Auth: UTi62CEg6qJ-4CVJ_bzkb70pAA8
Message-ID: <CAE9FiQWyCj1-MJE44pvw=vMFF1TADyqhLZJ7EvfFdEAFaX-4Uw@mail.gmail.com>
Subject: Re: PCI/e1000 BUG: unable to handle kernel paging request at 0ffff163
From: Yinghai Lu <yinghai@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 2:05 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> The root cause is memory corruption by the isdnloop driver:
>
> ==>     [    9.345694] isdnloop-ISDN-driver Rev 1.11.6.7
> ==>     [    9.347484] isdnloop: (loop0) virtual card added
>         [    9.348444] bus: 'usb': driver_probe_device: matched device 1-1:2.0 with driver cdc_acm
>         [    9.349773] bus: 'usb': really_probe: probing driver cdc_acm with device 1-1:2.0
>         [    9.350967] cdc_acm 1-1:2.0: This device cannot do calls on its own. It is not a modem.
>         [    9.353255] cdc_acm 1-1:2.0: ttyACM0: USB ACM device
>         [    9.354137] BUG: unable to handle kernel paging request at 0ffff163
>         [    9.355214] IP: [<0ffff163>] 0xffff162
>         [    9.355869] *pde = 00000000

good.
