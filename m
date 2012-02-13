Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2BMNJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 08:09:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2BMNJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:11 -0500
Date: Mon, 13 Feb 2012 14:09:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20120213130903.GA7355@redhat.com>
References: <20111111054731.GA2292@redhat.com>
 <20111111150105.GA25437@nomi.cz>
 <20111114140714.GD2513@redhat.com>
 <20111119181106.GA5515@nomi.cz>
 <1321755233.22510.1.camel@wwguy-ubuntu>
 <20111120032016.GA14520@nomi.cz>
 <1321763314.22510.4.camel@wwguy-ubuntu>
 <20111120204007.GA7273@nomi.cz>
 <20120210180929.GA17733@nomi.cz>
 <20120213092538.GA6214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120213092538.GA6214@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 10:25:39AM +0100, Stanislaw Gruszka wrote:
> On Fri, Feb 10, 2012 at 07:09:29PM +0100, Tomáš Janoušek wrote:
> > On Sun, Nov 20, 2011 at 09:40:07PM +0100, Tomáš Janoušek wrote:
> > > > Yes, I will try your configuration when I get back  to the office Monday
> > 
> > Did you have any luck?
> I think I tried to reproduce that problem and failed, but honestly I do
> not remember right now ...
> 
> > I just found out something which is almost completely
> > insane.
> > 
> > For the last few months, I've happily used a 64-bit kernel and have had no
> > problems whatsoever. About a week ago, I started using virtual machines in
> > KVM. And today I found that I have exactly the same problem, but only _inside_
> > the virtual machine. I can't reliably scp a file from the internet to my
> > virtual machine. It works fine when I scp to the host, it works fine when I'm
> > on a WPA-PSK network. And it happens even if I tell kvm to emulate e1000, not
> > only with virtio-net. How strange is that?
> >
> > And while this is happening, the host is running just fine. The host has a
> > 64-bit kernel with a 32-bit userspace, so if something was wrong with the
> > 32-bit mode of my processor, it would've appeared on the host as well, no?
> > 
> > It's also worth mentioning that if I build openssl with "no-asm 386", scp
> > works just fine. So it doesn't look like a memory corruption after all. It
> > seems as if certain CPU instructions didn't work properly if running on a
> > 32-bit kernel with a WiFi adapter doing something. But how can it be
> > that those same CPU instructions work on a 64-bit host with 32-bit userspace?
> > At the same time! That's just completely insane, and I can't think of an
> > explanation. Shall I get a new CPU perhaps? :-)
> 
> Currently there are discussion about compilator problems that
> can result a corruption
> http://lwn.net/Articles/478657/
> Perhaps this problem is something similar.
> 
> Also, if you look at lspci -vt, does it show that corruption happen
> only  when PCI bridge is used (however that would not explain why it
> only happens with WPA enterprise).

I also found this bug report
https://bugzilla.kernel.org/show_bug.cgi?id=37742
where one user report iwlwifi corruption catched by IOMMU.

Tomáš, I do not remember, do you have the same problems on
older kernels i.e < 3.0

Stanislaw
