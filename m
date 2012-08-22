Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab2HVJzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:55:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758775Ab2HVJy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:54:59 -0400
Message-ID: <5034AC61.9030704@redhat.com>
Date: Wed, 22 Aug 2012 12:54:41 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Tomas Racek <tracek@redhat.com>
CC: Michael Tokarev <mjt@tls.msk.ru>,
        Borislav Petkov <borislav.petkov@amd.com>,
        kvm-devel <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        Anthony Liguori <anthony@codemonkey.ws>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>
Subject: Re: [Qemu-devel] x86, nops settings result in kernel crash
References: <592618508.2357204.1345541334852.JavaMail.root@redhat.com>
In-Reply-To: <592618508.2357204.1345541334852.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 12:28 PM, Tomas Racek wrote:
> 
> http://fi.muni.cz/~xracek/debian2.img.bz2
> 
> Other things are the same.
> 
> The runtest.sh sets environment for xfstests and runs test 285 which I wrote and and which should test if FS sends discard requests only on free sectors:
> 285:
> 1. Create loop device and FS on it.
> 2. Populate it with some garbage.
> 3. Get free sectors from FS.
> 4. Run fstrim and look for discard requests via blk tracer.
> 5. Compare free sectors to discard requests.
> 
> The test itself can have some issues but I'm pretty sure it shouldn't crash the system. ;-)

Does the following patch help?

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index afb7ff7..ced4534 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -165,7 +165,7 @@ static int __init setup_noreplace_paravirt(char *str)
 #endif
 
 #ifdef P6_NOP1
-static const unsigned char  __initconst_or_module p6nops[] =
+static const unsigned char p6nops[] =
 {
 	P6_NOP1,
 	P6_NOP2,



-- 
error compiling committee.c: too many arguments to function
