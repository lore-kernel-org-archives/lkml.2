Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1BNTmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:42:15 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:7633 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751882Ab1BNTmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:42:12 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2cK1432N98dN4015Lzz1202hzz8275eh8275dha1495iz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGMHE5-01-8CB-02
X-M-MSG: 
Date: Mon, 14 Feb 2011 20:42:06 +0100
From: Robert Richter <robert.richter@amd.com>
To: Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>
Subject: Re: [patch v2 0/3] OProfile support for System z's hardware
 sampling
Message-ID: <20110214194206.GW5874@erda.amd.com>
References: <20110121100651.821690659@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110121100651.821690659@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heinz,

On 21.01.11 05:06:51, Heinz Graalfs wrote:
> I'm resending yesterday's mail because I missed to specify the correct sender information.
> 
> This is a re-posting of the patch series originally posted last month:
> 
> http://marc.info/?l=linux-s390&m=129285043619973&w=2
> 
> Heinz
> 
> Changes in
> 
> v2:
>    - kernel module hwsampler removed, everything is now in oprofile kernel module
>    - functions from hwsampler-main.c and smpctl.c merged into arch/s390/oprofile/hwsampler.c
>      - functions made static
>    - arch/s390/include/asm/hwsampler.h moved to arch/s390/oprofile/hwsampler.h
>      - structs have now hws_ prefix
>    - config variables changed, HAVE_HWSAMPLER used only
>    - original patch 4 (handle_munmap.patch) removed

thanks for you patches, I have applied them with modifications to:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git s390

For atomic compilation of single patches I changed patch order and the
Makefile where necessary. The branch also includes my follow-on
patches.

I will be travelling the next weeks and wanted to have this series in
linux-next now for later inclusion to .39. We would run out of time
otherwise (my bad). Please review and test the changes I made and send
me possibly updates.

Though I applied the patches I want to have the following changes:

* Merge init.c and hwsampler_file.c, two files are bloated here and
  hwsampler_file.c is a bad and too long naming.

* Rework functions in cpu_buffer.c (log_sample,
  __oprofile_add_ext_sample, oprofile_add_ext_hw_sample, etc.). All
  the (static) functions can be merged to a single functino by
  implementing a struct that holds all current function arguments.
  Something like:

static void __oprofile_add_ext_sample(struct *foobar fb);
void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
{
	struct foobar fb = { .regs = regs, .event = event };
	__oprofile_add_ext_sample(&fb);
}

  The naming and description of oprofile_add_ext_hw_sample() is also
  not the best. As interface in include/linux/oprofile.h we could then
  merge oprofile_add_ext_sample() and oprofile_add_ext_hw_sample() to
  a single function.

It would be nice if you could implement this.

For all patches in the oprofile/s390 branch I also need the
s390 maintainer's ack.

Martin or Heiko, please ack.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

