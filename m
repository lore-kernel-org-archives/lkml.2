Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab2DSWgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:36:44 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18797 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2DSWgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:36:42 -0400
MIME-Version: 1.0
Message-ID: <0b74f96b-8450-4dfb-8798-36edd0e06a64@default>
Date: Thu, 19 Apr 2012 15:36:29 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <nitingupta910@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: RE: linux-next: Tree for Apr 19 (zcache)
References: <20120419164643.d9f918d44c890722b7707508@canb.auug.org.au>
 <4F909200.6070104@xenotime.net>
In-Reply-To: <4F909200.6070104@xenotime.net>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F909372.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> Sent: Thursday, April 19, 2012 4:30 PM
> To: Stephen Rothwell
> Cc: linux-next@vger.kernel.org; LKML; Dan Magenheimer
> Subject: Re: linux-next: Tree for Apr 19 (zcache)
> 
> On 04/18/2012 11:46 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> >
> > Changes since 20120418:
> 
> 
> on x86_64:
> 
> drivers/built-in.o: In function `zv_free':
> zcache-main.c:(.text+0x5e1c9): undefined reference to `zs_map_object'
> zcache-main.c:(.text+0x5e238): undefined reference to `zs_unmap_object'
> zcache-main.c:(.text+0x5e29a): undefined reference to `zs_free'
> drivers/built-in.o: In function `zv_create':
> zcache-main.c:(.text+0x5e6b3): undefined reference to `zs_malloc'
> zcache-main.c:(.text+0x5e6f0): undefined reference to `zs_map_object'
> zcache-main.c:(.text+0x5e72c): undefined reference to `zs_unmap_object'
> drivers/built-in.o: In function `zcache_comp_init':
> zcache-main.c:(.text+0x5e831): undefined reference to `crypto_has_alg'
> zcache-main.c:(.text+0x5e8a5): undefined reference to `crypto_has_alg'
> drivers/built-in.o: In function `zcache_cpu_notifier':
> zcache-main.c:(.text+0x5e94f): undefined reference to `crypto_alloc_base'
> zcache-main.c:(.text+0x5e9f2): undefined reference to `crypto_destroy_tfm'
> drivers/built-in.o: In function `zv_decompress':
> zcache-main.c:(.text+0x5ee40): undefined reference to `zs_map_object'
> zcache-main.c:(.text+0x5ef06): undefined reference to `zs_unmap_object'
> drivers/built-in.o: In function `zcache_pampd_create':
> zcache-main.c:(.text+0x5f614): undefined reference to `zs_get_total_size_bytes'
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> Full randconfig file is attached.

This looks like issues with the zsmalloc code (http://lwn.net/Articles/474880/)
so forwarding to Seth/Nitin (cc Konrad).
