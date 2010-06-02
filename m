Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0FBOUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:20:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55597 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0FBOUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:20:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=qHnTYyoC7DH+gVm2Y8HKSfx6sim3NFaFydEiGfR69o8NW1GBXWTZJz8NGaUoZJVmmB
         jSd+tAZ0P/XoSUf+7RsothMEyGfCXOEDaDgE0T2dyYjQ6k9/7PBQBsrNEIk8aC2w6IWs
         owtPJsIP8IhiVPqpDfbVeOl0xgOhkMEzIIk3A=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Regression] [2.6.35-rc1] ssb_is_sprom_available
Date: Wed, 2 Jun 2010 16:20:13 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1; KDE/4.3.4; i686; ; )
Cc: Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>
References: <201005312155.20602.maciej.rutecki@gmail.com> <20100531205300.GB32708@parisc-linux.org> <20100601133402.GB26701@tuxdriver.com>
In-Reply-To: <20100601133402.GB26701@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021620.13266.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 1 czerwca 2010 o 15:34:02 John W. Linville wrote:
> On Mon, May 31, 2010 at 02:53:00PM -0600, Matthew Wilcox wrote:
> > On Mon, May 31, 2010 at 09:55:20PM +0200, Maciej Rutecki wrote:
> > > Last known good: 2.6.34
> > > Failing kernel: 2.6.35-rc1
> > >
> > > subsystem: PCI, USB(?)
> > >
> > > Kernel dies during booting on message "ssb_is_sprom_available", see
> > > picture:
> > > http://www.unixy.pl/maciek/download/kernel/2.6.35-rc1/gumis/DSC_0011.JP
> > >G
> >
> > Um, looks like it's something to do with the Sonics Silicon Backplane,
> > not PCI, nor USB.
> 
> Fix is on its way...
> 
> commit da1fdb02d9200ff28b6f3a380d21930335fe5429
> Author: Christoph Fritz <chf.fritz@googlemail.com>
> Date:   Fri May 28 10:45:59 2010 +0200
> 
>     ssb: fix NULL ptr deref when pcihost_wrapper is used
> 
>     Ethernet driver b44 does register ssb by it's pcihost_wrapper
>     and doesn't set ssb_chipcommon. A check on this value
>     introduced with commit d53cdbb94a52a920d5420ed64d986c3523a56743
>     and ea2db495f92ad2cf3301623e60cb95b4062bc484 triggers:
> 
>     BUG: unable to handle kernel NULL pointer dereference at 00000010
>     IP: [<c1266c36>] ssb_is_sprom_available+0x16/0x30
> 
>     Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 

Yes this commit solves problem. Thanks

Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
