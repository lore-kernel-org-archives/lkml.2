Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab2GKLXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:23:22 -0400
Received: from goliath.siemens.de ([192.35.17.28]:30384 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2GKLXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:23:20 -0400
Message-ID: <4FFD6221.1060304@siemens.com>
Date: Wed, 11 Jul 2012 13:23:13 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>, "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] kvm: level irqfd and new eoifd
References: <20120703191106.6735.78272.stgit@bling.home> <4FFD4D0A.2000202@redhat.com> <4FFD52E7.3030806@siemens.com> <4FFD5A2B.2040605@redhat.com>
In-Reply-To: <4FFD5A2B.2040605@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-11 12:49, Avi Kivity wrote:
> On 07/11/2012 01:18 PM, Jan Kiszka wrote:
>> On 2012-07-11 11:53, Avi Kivity wrote:
>>> On 07/03/2012 10:21 PM, Alex Williamson wrote:
>>>> Here's the latest iteration of adding an interface to assert and
>>>> de-assert level interrupts from external drivers like vfio.  These
>>>> apply on top of the previous argument cleanup, documentation, and
>>>> sanitization patches for irqfd.  It would be great to get this queued
>>>> in next for linux 3.6.
>>>>
>>>> I believe I've addressed all the previous comments, including fixing
>>>> the locking problems in eoifd.  I've run this with lockdep adding
>>>> and removing level irqfd/eoifd pairs without any problems.  Please
>>>> let me know if there are any further comments.  Thanks,
>>>
>>> Is there any performance justification for level irqfd?  Don't all
>>> new/high bandwidth devices support msi, and this is just a legacy path?
>>
>> I think we've been there before, but the situation hasn't improved much:
>>
>> Apparently, some GPUs still prefer INTx over MSI. Some wireless chipsets
>> too. 
> 
> I'd appreciate a couple of examples for formality's sake.

>From the top of my head: NVIDIA FX3700 (granted, legacy by now), Atheros
AR9287. For others, I need to check.

> 
>> And then there is not easily replaceable legacy hardware like old
>> telephony adapters or industrial I/O cards etc. that want this.
> 
> I imagine legacy hardware will live with the speed of routing through
> qemu, when running on modern platforms.

Just because it's "legacy" doesn't mean it's "low performance" and "low
interrupt rate".

We still have classic KVM device assignment to provide fast-path INTx.
But if we want to replace it midterm, I think it's necessary for VFIO to
be able to provide such a path as well.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
