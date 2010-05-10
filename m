Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab0EJUmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:42:04 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:33862 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191Ab0EJUl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:41:57 -0400
Date: Mon, 10 May 2010 21:41:49 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: nofpu and nodsp only affect CPU0
Message-ID: <20100510204148.GA959@linux-mips.org>
References: <0b6db1ee1efbe0daa1320b59ab5093ba5af377b8@localhost.localdomain>
 <20100510201959.GB28820@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510201959.GB28820@linux-mips.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 09:19:59PM +0100, Ralf Baechle wrote:

> > The "nofpu" and "nodsp" kernel command line options currently do not
> > affect CPUs that are brought online later in the boot process or
> > hotplugged at runtime.  It is desirable to apply the nofpu/nodsp options
> > to all CPUs in the system, so that surprising results are not seen when
> > a process migrates from one CPU to another.
> 
> I like this patch; this solution is also cleaner than iterating over the
> cpu data array.  However as it constitutes a change in established kernel
> behaviour I prefer to queue this patch for 2.6.35 rather than applying it
> immediately.

I've moved definitions of mips_fpu_disabled, fpu_disable, mips_dsp_disabled
and dsp_disable from setup.c to cpu-probe.c to allow mips_fpu_disabled and
mips_dsp_disabled to become static.

  Ralf
