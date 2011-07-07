Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1GGVEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:04:36 -0400
Received: from wnohang.net ([178.79.154.173]:39969 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab1GGVEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:04:35 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 8BDE7F0009
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 36659F0003
Date: Fri, 8 Jul 2011 02:34:29 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, jeremy.fitzhardinge@citrix.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [Xen-devel] Re: [PATCH] Modpost section mismatch fix
Message-ID: <20110707210429.GD4394@Xye>
References: <1309769388.634.51.camel@zakaz.uk.xensource.com>
 <20110704221646.GB4490@Xye>
 <20110705141323.GG2972@dumpdata.com>
 <20110705142731.GA4463@Xye>
 <20110705144846.GA13548@dumpdata.com>
 <20110705213243.GA3647@dumpdata.com>
 <20110707154648.GA4394@Xye>
 <20110707162454.GA8164@dumpdata.com>
 <20110707194851.GB4394@Xye>
 <20110707200949.GA25216@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20110707200949.GA25216@dumpdata.com>
X-Operating-System: Arch linux x86_64 3.0.0-rc5-LYM
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* On Thu, Jul 07, 2011 at 04:09:49PM -0400, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>On Fri, Jul 08, 2011 at 01:18:51AM +0530, Raghavendra D Prabhu wrote:
>> * On Thu, Jul 07, 2011 at 12:24:54PM -0400, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> >>Tested it. Works now.

>> >Ok, Stuck Tested-by on the patch. Hopefully Linus hasn't pulled it yet.
>> Ok.

>> >>Reviewed-by: Raghavendra Prabhu <rprabhu@wnohang.net>

>> >>Also,
>> >>The condition for acpi_gsi_to_irq can be removed since it always returns zero.

>> >The function might in the future return something that is non-zero
>> >and we should guard for it. Also you make 'irq' be unsigned which is not
>> >good as the IRQ 0 is a valid value - and with making it unsigned if it is
>> >set to -1 (the -1 is the invalid IRQ value) the check for 'irq != gsi'
>> >will be true and and we will pass in -1 casted to unsigned. That is a
>> >large value and not the right thing we want to pass to xen_register_gsi.

>> My rationale for the unsigned part was that acpi_gsi_to_irq always
>> assigns a positive value (>= 0) to the irq passed (as unsigned
>> argument). But even otherwise that shouldn't make much of difference I guess.

>> Also,
>> I had sent another change (oneline) for the file
>> arch/x86/xen/platform-pci-unplug.c for check_platform_magic, looks like that has not gone into
>> the pull request for Linus.
>
>Oh, I didn't see it. Did you CC me on it? Can you bounce it to me please?
>
=========================
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

--------------------------
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net
