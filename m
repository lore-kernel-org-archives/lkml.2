Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab2GKKSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:18:23 -0400
Received: from thoth.sbs.de ([192.35.17.2]:27582 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab2GKKSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:18:20 -0400
Message-ID: <4FFD52E7.3030806@siemens.com>
Date: Wed, 11 Jul 2012 12:18:15 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>, "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] kvm: level irqfd and new eoifd
References: <20120703191106.6735.78272.stgit@bling.home> <4FFD4D0A.2000202@redhat.com>
In-Reply-To: <4FFD4D0A.2000202@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-11 11:53, Avi Kivity wrote:
> On 07/03/2012 10:21 PM, Alex Williamson wrote:
>> Here's the latest iteration of adding an interface to assert and
>> de-assert level interrupts from external drivers like vfio.  These
>> apply on top of the previous argument cleanup, documentation, and
>> sanitization patches for irqfd.  It would be great to get this queued
>> in next for linux 3.6.
>>
>> I believe I've addressed all the previous comments, including fixing
>> the locking problems in eoifd.  I've run this with lockdep adding
>> and removing level irqfd/eoifd pairs without any problems.  Please
>> let me know if there are any further comments.  Thanks,
> 
> Is there any performance justification for level irqfd?  Don't all
> new/high bandwidth devices support msi, and this is just a legacy path?

I think we've been there before, but the situation hasn't improved much:

Apparently, some GPUs still prefer INTx over MSI. Some wireless chipsets
too. And then there is not easily replaceable legacy hardware like old
telephony adapters or industrial I/O cards etc. that want this.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux


