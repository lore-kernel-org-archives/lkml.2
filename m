Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0HDI4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:56:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab0HDI4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:56:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Dong, Eddie" <eddie.dong@intel.com>
Subject: Re: [RFC PATCH v8 00/16] Provide a zero-copy method on KVM virtio-net.
Date: Wed, 4 Aug 2010 10:56:07 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Shirley Ma <mashirle@us.ibm.com>, "Xin, Xiaohui" <xiaohui.xin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
References: <1280402088-5849-1-git-send-email-xiaohui.xin@intel.com> <201007311130.17000.arnd@arndb.de> <1A42CE6F5F474C41B63392A5F80372B228FCE7B1@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <1A42CE6F5F474C41B63392A5F80372B228FCE7B1@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008041056.08505.arnd@arndb.de>
X-Provags-ID: V02:K0:tRpbdNL5jGlZSXgNe6cS0xQjZZrD8gNpGRrm/qr1Hgz
 twwU1409NrptKKx/tiTKdqZWVm0IAxI62EDh3zc3PzgvP4cyqP
 9lMGfGKTfJ/NVRtNu/5+MmDwcb3qNE8WU/SPXJ6CodTH+xFg/z
 ZR47o4tEfetX6uea9exvxyANSm8Dg9EHQr97hfYkeHIC4KZyst
 cVJGC85x3PTE0i/y1jikw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 August 2010, Dong, Eddie wrote:
> Arnd Bergmann wrote:
> > On Friday 30 July 2010 17:51:52 Shirley Ma wrote:
> >> I think it should be less duplicated code in the kernel if we use
> >> macvtap to support what media passthrough driver here. Since macvtap
> >> has support virtio_net head and offloading already, the only missing
> >> func is zero copy. Also QEMU supports macvtap, we just need add a
> >> zero copy flag in option.
> > 
> > Yes, I fully agree and that was one of the intended directions for
> > macvtap to start with. Thank you so much for following up on that,
> > I've long been planning to work on macvtap zero-copy myself but it's
> > now lower on my priorities, so it's good to hear that you made
> > progress on it, even if there are still performance issues.
> > 
> 
> But zero-copy is a Linux generic feature that can be used by other
> VMMs as well if the BE service drivers want to incorporate.  If we
> can make mp device VMM-agnostic (it may be not yet in current patch),
> that will help Linux more.

But the tun/tap protocol is what most hypervisors use today on Linux,
and one of the design goals of macvtap was to keep that interface
so that everyone gets the features like zero-copy if that is added
to macvtap. The mp device interface is currently not supported by
anything else than vhost with these patches, and making it more
generic would turn the interface into a copy of macvtap.

	Arnd
