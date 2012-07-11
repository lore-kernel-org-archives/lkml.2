Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab2GKKtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:49:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab2GKKtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:49:19 -0400
Message-ID: <4FFD5A2B.2040605@redhat.com>
Date: Wed, 11 Jul 2012 13:49:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>, "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] kvm: level irqfd and new eoifd
References: <20120703191106.6735.78272.stgit@bling.home> <4FFD4D0A.2000202@redhat.com> <4FFD52E7.3030806@siemens.com>
In-Reply-To: <4FFD52E7.3030806@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 01:18 PM, Jan Kiszka wrote:
> On 2012-07-11 11:53, Avi Kivity wrote:
>> On 07/03/2012 10:21 PM, Alex Williamson wrote:
>>> Here's the latest iteration of adding an interface to assert and
>>> de-assert level interrupts from external drivers like vfio.  These
>>> apply on top of the previous argument cleanup, documentation, and
>>> sanitization patches for irqfd.  It would be great to get this queued
>>> in next for linux 3.6.
>>>
>>> I believe I've addressed all the previous comments, including fixing
>>> the locking problems in eoifd.  I've run this with lockdep adding
>>> and removing level irqfd/eoifd pairs without any problems.  Please
>>> let me know if there are any further comments.  Thanks,
>> 
>> Is there any performance justification for level irqfd?  Don't all
>> new/high bandwidth devices support msi, and this is just a legacy path?
> 
> I think we've been there before, but the situation hasn't improved much:
> 
> Apparently, some GPUs still prefer INTx over MSI. Some wireless chipsets
> too. 

I'd appreciate a couple of examples for formality's sake.

> And then there is not easily replaceable legacy hardware like old
> telephony adapters or industrial I/O cards etc. that want this.

I imagine legacy hardware will live with the speed of routing through
qemu, when running on modern platforms.

-- 
error compiling committee.c: too many arguments to function


