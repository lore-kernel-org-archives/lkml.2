Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574Ab2FDNQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:16:42 -0400
Received: from david.siemens.de ([192.35.17.14]:26214 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884Ab2FDNQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:16:41 -0400
Message-ID: <4FCCB531.4000008@siemens.com>
Date: Mon, 04 Jun 2012 15:16:33 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Avi Kivity <avi@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
References: <20120601161521.26935.25606.stgit@bling.home>   <4FC8F042.5050600@siemens.com> <1338570192.23475.25.camel@bling.home>  <4FC8F867.7080103@siemens.com> <1338573558.23475.41.camel@bling.home> <4FC90961.8030701@siemens.com> <4FCB2359.9020505@redhat.com> <alpine.LFD.2.02.1206041235540.3086@ionos> <4FCC9EAC.9090007@siemens.com> <alpine.LFD.2.02.1206041458490.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206041458490.3086@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-04 15:07, Thomas Gleixner wrote:
> On Mon, 4 Jun 2012, Jan Kiszka wrote:
>> On 2012-06-04 13:21, Thomas Gleixner wrote:
>> So this shortcut requires some checks before being applied to a specific
>> MSI/MSI-X vector.
>>
>>
>> Taking KVM aside, my general question remains if threaded MSI handlers
>> of all devices really need to apply IRQF_ONESHOT though they should have
>> no use for it.
> 
> In theory no, but we had more than one incident, where threaded irqs
> w/o a primary handler and w/o IRQF_ONEHSOT lead to full system
> starvation. Linus requested this sanity check and I think it's sane
> and required.

OK.

> 
> In fact it's a non issue for MSI. MSI uses handle_edge_irq which does
> not mask the interrupt. IRQF_ONESHOT is a noop for that flow handler.

Isn't irq_finalize_oneshot processes for all flows?

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
