Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1BOR3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:29:37 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:43033
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab1BOR3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:29:35 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGO5WH-02-HQG-02
X-M-MSG: 
Date: Tue, 15 Feb 2011 18:29:06 +0100
From: Robert Richter <robert.richter@amd.com>
To: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>
Subject: Re: [patch v2 0/3] OProfile support for System z's hardware
 sampling
Message-ID: <20110215172906.GG5874@erda.amd.com>
References: <20110121100651.821690659@linux.vnet.ibm.com>
 <20110214194206.GW5874@erda.amd.com>
 <1297789169.3231.9.camel@BR8HFPP0.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1297789169.3231.9.camel@BR8HFPP0.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.02.11 11:59:29, Heinz Graalfs wrote:

> > * Merge init.c and hwsampler_file.c, two files are bloated here and
> >   hwsampler_file.c is a bad and too long naming.
> > 
> 
> OK, I've merged all hwsampler_files.c contents into init.c
> 
> > * Rework functions in cpu_buffer.c (log_sample,
> >   __oprofile_add_ext_sample, oprofile_add_ext_hw_sample, etc.). All
> >   the (static) functions can be merged to a single functino by
> >   implementing a struct that holds all current function arguments.
> >   Something like:
> > 
> > static void __oprofile_add_ext_sample(struct *foobar fb);
> > void oprofile_add_sample(struct pt_regs * const regs, unsigned long event)
> > {
> > 	struct foobar fb = { .regs = regs, .event = event };
> > 	__oprofile_add_ext_sample(&fb);
> > }
> 
> OK, I've done this
> 
> > 
> >   The naming and description of oprofile_add_ext_hw_sample() is also
> >   not the best. As interface in include/linux/oprofile.h we could then
> >   merge oprofile_add_ext_sample() and oprofile_add_ext_hw_sample() to
> >   a single function.
> > 
> > It would be nice if you could implement this.
> 
> sure, I will do this, however I'm not sure what you exactly mean.
> Could you specify the interface in oprofile.h what you basically have in
> mind?

I mean to replace oprofile_add_ext_sample() and
oprofile_add_ext_hw_sample() by a new one. The interface would be in
the form of:

struct foobar {
       ...
}

static void __oprofile_add_ext_sample(struct *foobar fb);

Hope this makes sense. The advantage would be that we don't need to
extend the functions argument list anymore, we simply extend the
struct.

Please send me delta patches to oprofile/s390.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

