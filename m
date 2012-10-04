Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2JDUHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:07:52 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:19800 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2JDUHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:07:50 -0400
Message-ID: <506DEC95.8050806@hp.com>
Date: Thu, 04 Oct 2012 14:07:49 -0600
From: Randy Wright <rwright@hp.com>
Organization: Hewlett-Packard Company
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120824 Thunderbird/10.0.7
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, tmac@hp.com, hpa@zytor.com, rwright@hp.com
Subject: Re: [PATCH] Fix devmem_is_allowed for below 1MB accesses for an 
 efi machine
References: <jQim6-6MC-7@gated-at.bofh.it> <jQiFt-6UB-13@gated-at.bofh.it> <jQoUx-33k-3@gated-at.bofh.it> <jQp4d-37r-3@gated-at.bofh.it> <jQpxf-3Cv-1@gated-at.bofh.it>
In-Reply-To: <jQpxf-3Cv-1@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 11:20 PM, Matthew Garrett wrote:

> Oh, right, got you. In that case I think we potentially need a 
> finer-grained check on EFI platforms - the EFI memory map is kind enough 
> to tell us the difference between unusable regions and io regions, and 
> we could avoid access to the unusable ones.


I wanted to mention in this context a patch RFC I posted yesterday as a
distinct thread which is visible as https://lkml.org/lkml/2012/10/3/589
with the subject: [PATCH RFC] function probe_roms accessing improper
addresses on UEFI systems.

While the mechanism is different from Tmac's patch (because probe_roms
runs early in boot, prior to resource structure initialization) the
intent of the change is the same: to prevent a machine check resulting
from access to inappropriate physical addresses.

I will monitor both this thread as well as my own recent RFC posting
since the underlying issues are common.

-- 
Randy Wright        <rwright@hp.com>        +1-970-898-0998
