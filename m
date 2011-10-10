Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1JJRGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:06:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39936 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab1JJRF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:05:59 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: Re: Linux 3.1-rc9
Date: Mon, 10 Oct 2011 19:05:52 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9-00064-g65112dc-dirty; KDE/4.7.2; x86_64; ; )
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <4E925873.2020501@linux.vnet.ibm.com> <4E931BF6.6070706@linux.vnet.ibm.com>
In-Reply-To: <4E931BF6.6070706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110101905.52769.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 of October 2011, Rajiv Andrade wrote:
> On 09/10/11 23:29, Stefan Berger wrote:
> > On 10/09/2011 04:51 PM, Arkadiusz Miśkiewicz wrote:
> >> On Wednesday 05 of October 2011, Linus Torvalds wrote:
> >>> Another week, another -rc.
> >> 
> >> suspend to ram regression is annoying (still visible on rc9;
> >> https://lkml.org/lkml/2011/9/24/76) but unfortunately maintainers are
> >> silent.
> > 
> > I tried -rc9 on my Lenovo W500 with that same TPM. I cannot reproduce
> > the 'scheduling while atomic' problem you had reported earlier. I also
> > could suspend / resume fine as long as I did the following:
> > 
> > - suspended with the tpm_tis driver as module in the kernel
> > - once a suspend was done without the tpm_tis driver the subsequent
> > suspends were all done without the tpm_tis driver
> > 
> > Once I had done a suspend/resume with the tpm_tis driver *not* in the
> > kernel and then again a suspend with the tpm_tis driver in the kernel,
> > it did not resume anymore. I believe previously (previous version of
> > kernel and/or Fedora) it refused to even suspend. The reason why this
> > doesn't work properly is that the driver has to send a command to the
> > TPM upon suspend and the BIOS then sends the corresponding wakeup
> > command.
> > 
> > Did you maybe previously suspend/resume without a tpm_tis driver and
> > then try to suspend with it ?
> > 
> > Also, my Lenovo W500 shows particularly odd behavior when I switch
> > from Windows to Linux. The first suspend with a Linux booted after
> > Windows (with or without tpm_tis driver) does *not* resume (reboot
> > required). A subsequently rebooted Linux makes the suspend/resume work
> > fine.
> > 
> >    Stefan
> 
> Arkadiusz,
> 
> Do you still see the issue with this patch [1][2] applied?

The issue doesn't happen with this patch but error condition with "Could not 
read PCR 0. TPM is not working correctly." is triggered immediately at boot, 
even before suspend is used.

$ dmesg|grep -iE "(tpm|suspend)"
[   12.640039] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
[   12.640048] tpm_tis 00:0a: Intel iTPM workaround enabled
[   12.768057] tpm_tis 00:0a: Could not read PCR 0. TPM is not working 
correctly.
[   12.768066] tpm_tis 00:0a: Was machine previously suspended without TPM 
driver present?
[   88.512117] Suspending console(s) (use no_console_suspend to debug)


> 
> [1] - http://marc.info/?l=linux-kernel&m=131824905826280&w=2
> [2] - github.com/srajiv/tpm.git for-james
> 
> Thanks,
> Rajiv


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
