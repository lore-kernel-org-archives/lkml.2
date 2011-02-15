Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1BOREr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:04:47 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58143 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab1BOREp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:04:45 -0500
Subject: Re: [patch v2 0/3] OProfile support for System z's hardware
 sampling
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>
In-Reply-To: <20110214194206.GW5874@erda.amd.com>
References: <20110121100651.821690659@linux.vnet.ibm.com>
	 <20110214194206.GW5874@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 17:59:29 +0100
Message-ID: <1297789169.3231.9.camel@BR8HFPP0.boeblingen.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

thanks for the positive reply.

Please see my comments below. I suppose I still need some more detailed
directions from you.
Unfortunately I will not be in the office Thursday and Friday.

Heinz

On Mon, 2011-02-14 at 20:42 +0100, Robert Richter wrote:
> Heinz,
> 
> On 21.01.11 05:06:51, Heinz Graalfs wrote:
> > I'm resending yesterday's mail because I missed to specify the correct sender information.
> > 
> > This is a re-posting of the patch series originally posted last month:
> > 
> > http://marc.info/?l=linux-s390&m=129285043619973&w=2
> > 
> > Heinz
> > 
> > Changes in
> > 
> > v2:
> >    - kernel module hwsampler removed, everything is now in oprofile kernel module
> >    - functions from hwsampler-main.c and smpctl.c merged into arch/s390/oprofile/hwsampler.c
> >      - functions made static
> >    - arch/s390/include/asm/hwsampler.h moved to arch/s390/oprofile/hwsampler.h
> >      - structs have now hws_ prefix
> >    - config variables changed, HAVE_HWSAMPLER used only
> >    - original patch 4 (handle_munmap.patch) removed
> 
> thanks for you patches, I have applied them with modifications to:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git s390
> 
> For atomic compilation of single patches I changed patch order and the
> Makefile where necessary. The branch also includes my follow-on
> patches.
> 
> I will be travelling the next weeks and wanted to have this series in
> linux-next now for later inclusion to .39. We would run out of time
> otherwise (my bad). Please review and test the changes I made and send
> me possibly updates.
> 
> Though I applied the patches I want to have the following changes:
> 
> * Merge init.c and hwsampler_file.c, two files are bloated here and
>   hwsampler_file.c is a bad and too long naming.
> 

OK, I've merged all hwsampler_files.c contents into init.c

> * Rework functions in cpu_buffer.c (log_sample,
>   __oprofile_add_ext_sample, oprofile_add_ext_hw_sample, etc.). All
>   the (static) functions can be merged to a single functino by
>   implementing a struct that holds all current function arguments.
>   Something like:
> 
> static void __oprofile_add_ext_sample(struct *foobar fb);
> void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
> {
> 	struct foobar fb = { .regs = regs, .event = event };
> 	__oprofile_add_ext_sample(&fb);
> }

OK, I've done this

> 
>   The naming and description of oprofile_add_ext_hw_sample() is also
>   not the best. As interface in include/linux/oprofile.h we could then
>   merge oprofile_add_ext_sample() and oprofile_add_ext_hw_sample() to
>   a single function.
> 
> It would be nice if you could implement this.

sure, I will do this, however I'm not sure what you exactly mean.
Could you specify the interface in oprofile.h what you basically have in
mind?

> 
> For all patches in the oprofile/s390 branch I also need the
> s390 maintainer's ack.
> 
> Martin or Heiko, please ack.
> 
> Thanks,
> 
> -Robert
> 


