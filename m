Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab2FNSFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 14:05:37 -0400
Received: from smtp.citrix.com ([66.165.176.89]:12125 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab2FNSFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:05:36 -0400
X-IronPort-AV: E=Sophos;i="4.75,770,1330923600"; 
   d="scan'208";a="28120282"
Message-ID: <4FDA27ED.1080404@citrix.com>
Date: Thu, 14 Jun 2012 19:05:33 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/xen: avoid updating TLS descriptors if they haven't
 changed
References: <1339088494-23528-1-git-send-email-david.vrabel@citrix.com> <4FD9FAA3.6090303@citrix.com> <20120614164926.GC333@phenom.dumpdata.com>
In-Reply-To: <20120614164926.GC333@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/12 17:49, Konrad Rzeszutek Wilk wrote:
> On Thu, Jun 14, 2012 at 03:52:19PM +0100, David Vrabel wrote:
>> On 07/06/12 18:01, David Vrabel wrote:
>>> From: David Vrabel <david.vrabel@citrix.com>
>>>
>>> When switching tasks in a Xen PV guest, avoid updating the TLS
>>> descriptors if they haven't changed.  This improves the speed of
>>> context switches by almost 10% as much of the time the descriptors are
>>> the same or only one is different.
>>>
>>> The descriptors written into the GDT by Xen are modified from the
>>> values passed in the update_descriptor hypercall so we keep shadow
>>> copies of the three TLS descriptors to compare against.
>>>
>>> lmbench3 test     Before  After  Improvement
>>> --------------------------------------------
>>> lat_ctx -s 32 24   7.19    6.52  9%
>>> lat_pipe          12.56   11.66  7%
>>>
>>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>>> ---
>>> I note that the comment in asm/desc_defs.h says the 'a' and 'b' fields
>>> in desc_struct as deprecated but there seems to be no suitable
>>> alternatives.
>>
>> ping?  Any opinion on this patch from the x86 side?  If it's okay can we
>> get an ack so Konrad can take the patch via his tree.
> 
> It breaks my all my bootup tests - so NACK until at least that is fixed.
> I think I sent you the whole serial log - is there something else that would help
> narrow it down?

You're mixing up this patch with "xen/mm: do direct hypercall in
xen_set_pte() if batching is unavailable" which is broken on 64-bit and
I am looking into it.

David
