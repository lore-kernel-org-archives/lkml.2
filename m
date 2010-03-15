Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937186Ab0COX2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:28:48 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:53483 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564Ab0COX2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qEorLpKg3VdnemJgmf3/Oe2zkJOucxDJlxVClguNPr1Gbtd52m+6TIuwtacuKu4QMO
         mSsldRT5v1VbFGSLNLSssX5rnUCARe5en56J+aGuH61j1xvG9APT3fRZRr04rzSmbKF+
         xJxmVu1aZmEe7Y+uoWsd/1AosgIHUQSYhGnA0=
MIME-Version: 1.0
In-Reply-To: <20100315.115748.13754030.davem@davemloft.net>
References: <20100315150806.GA15354@Dublin.logfs.org>
	 <20100315151041.GA15667@Dublin.logfs.org>
	 <20100315.115748.13754030.davem@davemloft.net>
Date: Mon, 15 Mar 2010 17:28:45 -0600
Message-ID: <51f3faa71003151628g5edc4d7av8916ac76cb337bfe@mail.gmail.com>
Subject: Re: [Regression] r8169: enable 64-bit DMA by default for PCI Express 
	devices (v2)
From: Robert Hancock <hancockrwd@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: joern@dublin.logfs.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       romieu@fr.zoreil.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 12:57 PM, David Miller <davem@davemloft.net> wrote:
> From: Jörn Engel <joern@dublin.logfs.org>
> Date: Mon, 15 Mar 2010 16:10:41 +0100
>
>> Forgot to Cc: lkml.
>
> Actually, what you really need to CC: is netdev, added.
>> On Mon, 15 March 2010 16:08:06 +0100, J�rn Engel wrote:
>>>
>>> Hello Robert!
>>>
>>> Looks like 353176888386d9025062a12dcec08d49af10cf2c broke one of my
>>> machines.  Reverting that patch fixes things again.  Machine is
>>> running an x86_64 kernel.  Lspci gives me this:
>>>
>>> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
>>>         Subsystem: ASRock Incorporation Device 8136
>>>         Flags: bus master, fast devsel, latency 0, IRQ 26
>>>         I/O ports at e800 [size=256]
>>>         Memory at fdeff000 (64-bit, prefetchable) [size=4K]
>>>         Memory at fdee0000 (64-bit, prefetchable) [size=64K]
>>>         [virtual] Expansion ROM at fde00000 [disabled] [size=128K]
>>>         Capabilities: [40] Power Management version 3
>>>         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>>         Capabilities: [70] Express Endpoint, MSI 01
>>>         Capabilities: [ac] MSI-X: Enable- Count=2 Masked-
>>>         Capabilities: [cc] Vital Product Data
>>>         Capabilities: [100] Advanced Error Reporting
>>>         Capabilities: [140] Virtual Channel <?>
>>>         Capabilities: [160] Device Serial Number 08-00-00-00-ff-ff-00-00
>>>         Kernel driver in use: r8169
>>>
>>> If you have any test patches to try, please send them my way. :)
>>>
>>> J�rn
>

What are the symptoms? Does setting use_dac=0 in the module options
for r8169 also resolve the problem?

Full dmesg and lspci -vv output might also be useful.
