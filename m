Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab0IOI3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:29:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab0IOI3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:29:15 -0400
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>,
        DavidHowells <dhowells@redhat.com>
In-Reply-To: <1284528590.2256.135.camel@yhuang-dev.sh.intel.com>
References: <1284360648.3269.115.camel@yhuang-dev.sh.intel.com>
	 <20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com>
	 <1284377790.2275.212.camel@laptop>
	 <1284528590.2256.135.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Sep 2010 10:28:40 +0200
Message-ID: <1284539320.3764.266.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 13:29 +0800, Huang Ying wrote:

> I uses the cross build tool from:
> 
> http://www.kernel.org/pub/tools/crosstool/

I'm not familiar with those, I build my own gcc-4.5.1 toolchains for all
targets that would actually build a gcc toolchains, for those that don't
I simply don't care about.

> But I get compile errors on s390 and alpha even for tip/master
> (ce0c65112d37ff04016b4e0962a406281640739b). The build logs are attached.

I've got a patch to solve the Alpha issue, and I've got a patch for one
of the SH issues as well, but I understand you need to pull in Paul
Mundt's SH tree to make it fully build.

I've asked Ingo to merge the Alpha and SH patches I had pending.

> Do I use the wrong git tree? Or we should fix tip/master firstly?
> 
> And frv and sh have compile error even for linus/master and 2.6.35. So I
> can not compile test for these arches.

FRV is one of those architectures that doesn't build a toolchain from
plain gcc sources, David Howells did provide me with a toolchain for
that, it does build, but really it should be getting its toolchain
sorted upstream.


