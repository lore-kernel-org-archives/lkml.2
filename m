Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0FCPzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:55:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55072 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab0FCPzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=DCAasWKB7a6Le+eRvoerp50zXzZH4LUX66QMZ/dMfs43ALuYQR66wvv0VhL5j2VXci
         3IYKszYYfWE1S5HkB+YuMdPNmEIrgCRsN26AA32gIdcFIPajITliNfH2tNO3De19HTYz
         ZF4fk8D1eDqjsrkcSpd/Rxszct1hM6YUa/Qa8=
Date: Thu, 3 Jun 2010 19:55:05 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Luming Yu <luming.yu@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100603155505.GA7510@oksana.dev.rtsoft.ru>
References: <AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
 <AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
 <20100603093923.GA25856@oksana.dev.rtsoft.ru>
 <AANLkTim8TALR8Ev9KDX4tteXUrQ3oKOcnyMHk9WOdUvG@mail.gmail.com>
 <20100603131414.GA23520@oksana.dev.rtsoft.ru>
 <20100603132319.GA4889@oksana.dev.rtsoft.ru>
 <20100603135031.GA9964@oksana.dev.rtsoft.ru>
 <AANLkTimRDNiN-rOl-V-WnRiVwXNaZ8sPPmj_TzsNLZmq@mail.gmail.com>
 <20100603150422.GA31604@oksana.dev.rtsoft.ru>
 <20100603154533.GA11525@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100603154533.GA11525@hack>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:45:33PM +0800, Américo Wang wrote:
> On Thu, Jun 03, 2010 at 07:04:22PM +0400, Anton Vorontsov wrote:
> >On Thu, Jun 03, 2010 at 10:13:57PM +0800, Luming Yu wrote:
> >> On Thu, Jun 3, 2010 at 9:50 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> >> > On Thu, Jun 03, 2010 at 05:23:19PM +0400, Anton Vorontsov wrote:
> >> > [...]
> >> >> Oh. It seems I found it. It must be the module order loading
> >> >> thing.
> >> >>
> >> >> Can you try the patch down below?
> >> >
> >> > OTOH... libahci is a link-time dependency. And the order doesn't
> >> > matter here. So you should just have the libahci module in
> >> > the initrd (actually, mkinitrd or whatever you use should
> >> > have included this automatically).
> >> >
> >> 
> >> Neither ahci nor libachi is automatically included in initrd..
> >
> >What commands you use to build the kernel and initrd?
> >
> >> Manually added ahci and libachi into initrd seems to make the problem go away..
> >> Any idea why that could happen?
> >
> >No idea off hand.
> >
> >Cc'ing Kbuild folks. Question is: is there something wrong with
> >writing stuff like this:
> >obj-$(CONFIG_SATA_AHCI)         += ahci.o libahci.o
> >obj-$(CONFIG_SATA_AHCI_PLATFORM) += ahci_platform.o libahci.o
> >as in drivers/ata/Makefile?
> >
> >It seem to link fine, .ko's are created. But for some reason
> >initrd doesn't include these modules for Luming...
> >
> 
> Odd.
> Are these modules exported to /lib/modules/`uname -r`/ directory?

At least for me, yes (debian sid). It all looks sane.

$ find /tmp/abc/
/tmp/abc/
/tmp/abc/lib
/tmp/abc/lib/modules
/tmp/abc/lib/modules/2.6.35-rc1+
/tmp/abc/lib/modules/2.6.35-rc1+/modules.dep
/tmp/abc/lib/modules/2.6.35-rc1+/modules.dep.bin
/tmp/abc/lib/modules/2.6.35-rc1+/modules.alias
/tmp/abc/lib/modules/2.6.35-rc1+/modules.softdep
/tmp/abc/lib/modules/2.6.35-rc1+/source
/tmp/abc/lib/modules/2.6.35-rc1+/modules.symbols
/tmp/abc/lib/modules/2.6.35-rc1+/kernel
/tmp/abc/lib/modules/2.6.35-rc1+/kernel/drivers
/tmp/abc/lib/modules/2.6.35-rc1+/kernel/drivers/ata
/tmp/abc/lib/modules/2.6.35-rc1+/kernel/drivers/ata/ahci_platform.ko
/tmp/abc/lib/modules/2.6.35-rc1+/kernel/drivers/ata/libahci.ko
/tmp/abc/lib/modules/2.6.35-rc1+/kernel/drivers/ata/ahci.ko
/tmp/abc/lib/modules/2.6.35-rc1+/kernel/drivers/scsi
/tmp/abc/lib/modules/2.6.35-rc1+/kernel/drivers/scsi/scsi_wait_scan.ko
/tmp/abc/lib/modules/2.6.35-rc1+/modules.builtin.bin
/tmp/abc/lib/modules/2.6.35-rc1+/modules.alias.bin
/tmp/abc/lib/modules/2.6.35-rc1+/build
/tmp/abc/lib/modules/2.6.35-rc1+/modules.order
/tmp/abc/lib/modules/2.6.35-rc1+/modules.symbols.bin
/tmp/abc/lib/modules/2.6.35-rc1+/modules.builtin
$ cat /tmp/abc/lib/modules/2.6.35-rc1+/modules.dep
kernel/drivers/scsi/scsi_wait_scan.ko:
kernel/drivers/ata/libahci.ko:
kernel/drivers/ata/ahci.ko: kernel/drivers/ata/libahci.ko
kernel/drivers/ata/ahci_platform.ko: kernel/drivers/ata/libahci.ko

I just found Fedora's mkinitrd, and I see this:

~/mkinitrd$ git grep -A 5 -B 5 ahci
functions-    for m in $items ; do
functions-      char=$(echo $m | cut -c1)
functions-      if [ $char = '=' ]; then
functions-          NAME=$(echo $m | cut -c2-)
functions-          if [ "$NAME" = "ata" ]; then
functions:              MODS="$MODS $(cat /lib/modules/$kernel/modules.block |egrep '(ata|ahci)' |sed -e 's/.ko//')"
functions-          else
functions-                # Ignore if group list does not exist
functions-                if [ -e /lib/modules/$kernel/modules.$NAME ]; then
functions-                  MODS="$MODS $(cat /lib/modules/$kernel/modules.$NAME |sed -e 's/.ko//')"
functions-                fi

Hm? What is this? Maybe it breaks when it sees libahci?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
