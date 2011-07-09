Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1GIQ3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 12:29:15 -0400
Received: from wnohang.net ([178.79.154.173]:58904 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab1GIQ3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 12:29:14 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 34138F000A
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 06D31F0003
Date: Sat, 9 Jul 2011 21:59:07 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org, Ian Campbell <ijc@hellion.org.uk>,
        xen-devel@lists.xensource.com, jeremy.fitzhardinge@citrix.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [TOME] Re: [Xen-devel] Re: [PATCH] Modpost section mismatch fix
 (for platform-pci-unplug.c)
Message-ID: <20110709162907.GA4437@Xye>
References: <20110705141323.GG2972@dumpdata.com>
 <20110705142731.GA4463@Xye>
 <20110705144846.GA13548@dumpdata.com>
 <20110705213243.GA3647@dumpdata.com>
 <20110707154648.GA4394@Xye>
 <20110707162454.GA8164@dumpdata.com>
 <20110707194851.GB4394@Xye>
 <20110707200949.GA25216@dumpdata.com>
 <20110707210429.GD4394@Xye>
 <20110708202628.GA25998@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20110708202628.GA25998@dumpdata.com>
X-Operating-System: Arch linux x86_64 3.0.0-rc6-LYM
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* On Fri, Jul 08, 2011 at 04:26:28PM -0400, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> >>Also,
>> >>I had sent another change (oneline) for the file
>> >>arch/x86/xen/platform-pci-unplug.c for check_platform_magic, looks like that has not gone into
>> >>the pull request for Linus.

>> >Oh, I didn't see it. Did you CC me on it? Can you bounce it to me please?

>> =========================
>>  diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
>>  index 25c52f9..ffcf261 100644
>>  --- a/arch/x86/xen/platform-pci-unplug.c
>>  +++ b/arch/x86/xen/platform-pci-unplug.c
>>  @@ -35,7 +35,7 @@ EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
>>   #ifdef CONFIG_XEN_PVHVM
>>   static int xen_emul_unplug;

>>  -static int __init check_platform_magic(void)
>>  +static int check_platform_magic(void)
>>   {
>>          short magic;
>>          char protocol;
>>  --

>
>Yeah, that would cause an issue during suspend/resume by PVonHVM. How
>we didn't trip over this I've no idea..
>
>Anyhow, can you provide me with your Signed-off-by please and I will queue
>it right up.
Sorry for missing the Signed-off thing (was there in original one I had sent).
===========================================================

   Removing __init from check_platform_magic since it is called by
xen_unplug_emulated_devices in non-init contexts (It probably gets inlined
because of -finline-functions-called-once, removing __init is more to avoid
mismatch being reported).

  Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
  ---
   arch/x86/xen/platform-pci-unplug.c |    2 +-

  diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
  index fe00830..fb5eeb0 100644
  --- a/arch/x86/pci/xen.c
  +++ b/arch/x86/pci/xen.c
  @@ -327,7 +327,7 @@ int __init pci_xen_hvm_init(void)
   }

   #ifdef CONFIG_XEN_DOM0
  -static int xen_register_pirq(u32 gsi, int triggering)
  +static  __refdata  int xen_register_pirq(u32 gsi, int triggering)
   {
          int rc, pirq, irq = -1;
          struct physdev_map_pirq map_irq;
  diff --git a/arch/x86/xen/platform-pci-unplug.c b/arch/x86/xen/platform-pci-unplug.c
  index 25c52f9..ffcf261 100644
  --- a/arch/x86/xen/platform-pci-unplug.c
  +++ b/arch/x86/xen/platform-pci-unplug.c
  @@ -35,7 +35,7 @@ EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
   #ifdef CONFIG_XEN_PVHVM
   static int xen_emul_unplug;

  -static int __init check_platform_magic(void)
  +static int check_platform_magic(void)
   {
          short magic;
          char protocol;
  --

>
>Stefano, you OK with this patch?
>
--------------------------
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net
