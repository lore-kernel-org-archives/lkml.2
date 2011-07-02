Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1GBTmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:42:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49429 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1GBTmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 15:42:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] ARM: convert PCI defines to variables
Date: Sat, 2 Jul 2011 21:41:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, Michal Simek <monstr@monstr.eu>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        nico@fluxnic.net
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com> <201107021121.46701.arnd@arndb.de> <4E0F11B3.30803@gmail.com>
In-Reply-To: <4E0F11B3.30803@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107022141.31972.arnd@arndb.de>
X-Provags-ID: V02:K0:FyQBPFeS3EZ23ajBn8dZv1wW4hx/zUU5Rh6eNfiZCMW
 vsgwIHYiVmZcy1aGLa5jvVjDCL3IwQytcbvkwjyeaK0i1KpU4I
 0tpbHrG27r72+8Y02wR2Mah5aHaemR5oYgKH6e0bOTbsLOHcTr
 oFXSGe8OX8ngS1rFveNJkZzr6H3M79DmreizcvwDgdN7HQGH5B
 pZG/j6iPj+4V8myAI3nqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011 14:40:19 Rob Herring wrote:
> > Basically, the defaults should clearly be 
> > 
> > unsigned long pcibios_min_io  = 0x1000;
> > unsigned long pcibios_min_mem = 0x01000000;
> > 
> > This just gets us out of the ISA bus range, so an ISA card behind
> > a bridge can use all cards correctly. Most of the ones that
> > currently set both to zero can probably just use those defaults
> > as well, but some architectures have multiple buses or don't start
> > the memory range at zero, so they might need higher values.
> 
> For many platforms, the defaults are 0 for both of these, so I went with
> that. Do you think those are just wrong?

They prevent you from having a VGA card or anything else that uses the
legacy ISA I/O ranges on the PCI bus, so it's a bad default.

However, some platforms may have specific reasons not to use these
values but instead start the address allocation at zero. E.g. the
memory window may be severely limited in some implementations, so
you can't afford to lose the first 16 MB.

I would make the default 0x1000/0x01000000 and specifically set the
platforms that require other values, possibly with a comment questioning
whether that's a good choice.

	Arnd
