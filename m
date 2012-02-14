Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920Ab2BNJVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:21:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab2BNJU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:20:59 -0500
Date: Tue, 14 Feb 2012 10:20:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>, security@kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20120214092020.GB12905@redhat.com>
References: <20111110163051.GA24533@nomi.cz>
 <20111111054731.GA2292@redhat.com>
 <20111111150105.GA25437@nomi.cz>
 <20111114140714.GD2513@redhat.com>
 <20111119181106.GA5515@nomi.cz>
 <1321755233.22510.1.camel@wwguy-ubuntu>
 <20111120032016.GA14520@nomi.cz>
 <1321763314.22510.4.camel@wwguy-ubuntu>
 <20111120204007.GA7273@nomi.cz>
 <20120210180929.GA17733@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120210180929.GA17733@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 07:09:29PM +0100, Tomáš Janoušek wrote:
> For the last few months, I've happily used a 64-bit kernel and have had no
> problems whatsoever. About a week ago, I started using virtual machines in
> KVM. And today I found that I have exactly the same problem, but only _inside_
> the virtual machine. I can't reliably scp a file from the internet to my
> virtual machine. It works fine when I scp to the host, it works fine when I'm
> on a WPA-PSK network. And it happens even if I tell kvm to emulate e1000, not
> only with virtio-net. How strange is that?
> 
> And while this is happening, the host is running just fine. The host has a
> 64-bit kernel with a 32-bit userspace, so if something was wrong with the
> 32-bit mode of my processor, it would've appeared on the host as well, no?
> 
> It's also worth mentioning that if I build openssl with "no-asm 386", scp
> works just fine.
Good hint.

> So it doesn't look like a memory corruption after all. It
> seems as if certain CPU instructions didn't work properly if running on a
> 32-bit kernel with a WiFi adapter doing something. But how can it be
> that those same CPU instructions work on a 64-bit host with 32-bit userspace?
> At the same time! That's just completely insane, and I can't think of an
> explanation. Shall I get a new CPU perhaps? :-)
>
> 
> Please, give me any ideas that you might have.

That make sense! Your "CPU instructions break things" theory sounds crazy,
but I think it's logical. WPA enterprise differ from WPA-PSA (pre shared
key) that the key changed periodically, SSL is used when keys are changed
(via wpa_supplicant). So looks like 32-bit openssl generate object code
that trigger bug on CPU, which crash other processes.

Please forward details about this issue to security@kernel.org and proper
vendor engineer in non public manner, as this hw bug could be possibly
exploitable (hardware bug can not be fixed, but kernel could disable
appropriate functionality or use some other workaround).

Thanks
Stanislaw
