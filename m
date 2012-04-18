Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2DROGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:06:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab2DROGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:06:19 -0400
Message-ID: <4F8ECA4F.7070305@redhat.com>
Date: Wed, 18 Apr 2012 17:06:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Nadav Har'El" <nyh@math.technion.ac.il>
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F84E0DF.8040206@cn.fujitsu.com> <4F8D1F46.3090901@redhat.com> <4F8D9F20.9050507@codemonkey.ws> <4F8EAFF7.2040505@redhat.com> <20120418134743.GA25786@fermat.math.technion.ac.il>
In-Reply-To: <20120418134743.GA25786@fermat.math.technion.ac.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 04:47 PM, Nadav Har'El wrote:
> On Wed, Apr 18, 2012, Avi Kivity wrote about "Re: [PATCH 0/4] Export offsets of VMCS fields as note information for kdump":
> > Right; they're also not required to be in memory at all - the processor
> > can cache them, even for VMCSs that are not active at this time. 
> > Running VMXOFF at panic time can fix that, but you have to broadcast it
> > to all processors, probably using NMI...
>
> I believe that a VMCLEAR ensures that the VMCS is written back to
> memory. KVM uses this fact when migrating a VMCS between two separate
> physical CPUs - it runs VMCLEAR on the old CPU, to write the VMCS to
> memory, and then VMPTRLD on the new CPU.
>
> So you don't need to VMXOFF, but do need to VMCLEAR. But there's still
> the complication that you mention - you need to do the VMCLEAR on the right
> processor...

VMCLEAR only clears one VMCS; several may be cached by a processor at
one time.  Presumably VMXOFF flushes everything.

-- 
error compiling committee.c: too many arguments to function

