Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2DRN5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:57:46 -0400
Received: from mailgw13.technion.ac.il ([132.68.225.13]:49128 "EHLO
	mailgw13.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2DRN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:57:45 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2012 09:57:44 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAMHFjk+ERHMG/2dsb2JhbABEsT6BB4IKAQU6Pw4CC0YUBxExE4gPsUyJCQSQAWMEiFaNGAGBEY8pgmo
X-IronPort-AV: E=Sophos;i="4.75,442,1330898400"; 
   d="scan'208";a="5854688"
Date: Wed, 18 Apr 2012 16:47:44 +0300
From: "Nadav Har'El" <nyh@math.technion.ac.il>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, kvm@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
Message-ID: <20120418134743.GA25786@fermat.math.technion.ac.il>
References: <4F84E0DF.8040206@cn.fujitsu.com>
 <4F8D1F46.3090901@redhat.com>
 <4F8D9F20.9050507@codemonkey.ws>
 <4F8EAFF7.2040505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8EAFF7.2040505@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012, Avi Kivity wrote about "Re: [PATCH 0/4] Export offsets of VMCS fields as note information for kdump":
> Right; they're also not required to be in memory at all - the processor
> can cache them, even for VMCSs that are not active at this time. 
> Running VMXOFF at panic time can fix that, but you have to broadcast it
> to all processors, probably using NMI...

I believe that a VMCLEAR ensures that the VMCS is written back to
memory. KVM uses this fact when migrating a VMCS between two separate
physical CPUs - it runs VMCLEAR on the old CPU, to write the VMCS to
memory, and then VMPTRLD on the new CPU.

So you don't need to VMXOFF, but do need to VMCLEAR. But there's still
the complication that you mention - you need to do the VMCLEAR on the right
processor...


-- 
Nadav Har'El                        |                 Wednesday, Apr 18 2012, 
nyh@math.technion.ac.il             |-----------------------------------------
Phone +972-523-790466, ICQ 13349191 |The only "intuitive" interface is the
http://nadav.harel.org.il           |nipple. After that, it's all learned.
