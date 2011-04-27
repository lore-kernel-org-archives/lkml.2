Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1D0Mce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:32:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab1D0Mcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:32:33 -0400
Date: Wed, 27 Apr 2011 15:32:13 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH][RESEND] Fix EDD3.0 data verification.
Message-ID: <20110427123213.GL2265@redhat.com>
References: <20110426082132.GG2265@redhat.com>
 <4DB74A6C.2080702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB74A6C.2080702@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 03:42:52PM -0700, H. Peter Anvin wrote:
> On 04/26/2011 01:21 AM, Gleb Natapov wrote:
> > +
> > +	/* We support only T13 spec */
> > +	if (info->params.device_path_info_length != 44)
> > +		return 0;
> > +
> 
> Please make it work correctly with both versions of the structure, instead.
> 
Current Linux EDD support is written to conform to T13 standard as it
says in the file header:

 * BIOS Enhanced Disk Drive Services (EDD)
 * conformant to T13 Committee www.t13.org
 *   projects 1572D, 1484D, 1386D, 1226DT

This patch is only fixes obviously incorrect code in edd_has_edd30()
to do proper check instead of summing random memory and it should be
applied even if we decide that we want to support Phoenix spec too.

I looked into implementing support for Phoenix spec back then when I
wrote the patch and I decided against it. The main (and may be only)
use case for edd module is to provide OS installer with enough info
for it to decide where to install boot loader. Unfortunately Phoenix
EDD spec does not support most modern storage technologies and even for
legacy one such as ATA it does not provide enough info to determine boot
disk correctly (you can't tell the difference between two ATA channels,
T13 spec provides this info in interface path along with PCI address).
So even if we would have support for it the OS installer will have to
check if the information comes from T13 or Phoenix and ignore it if it's
the later.

--
			Gleb.
