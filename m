Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2K3KxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:53:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59150 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab2K3KxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:53:15 -0500
Date: Fri, 30 Nov 2012 11:53:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] aerdrv: Trace Event for AER
Message-ID: <20121130105311.GA6869@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
	lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
	mchehab@redhat.com, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121129215443.5483.43364.stgit@grignak.americas.hpqcorp.net>
 <1354240279.6276.131.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354240279.6276.131.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 08:51:19PM -0500, Steven Rostedt wrote:
> >  include/ras/aer_event.h |   77 +++++++++++++++++++++++++++++++++++++++++++++++
> 
> Is there a reason this header is here? Egad, I never noticed the
> ras_event.h that is there. This include/ras directory was created for
> the sole purpose of trace events! This is not the way to do this.

Well, the idea for the ras event was to be able to use it in multiple
places. It is currently used only by EDAC but it could be that memory
errors could be reported by other agents which would reuse that TP.

> Please look at the sample in samples/trace_events/
> 
> The proper way is to keep the header by the driver. Then you can simply
> include the header with "aer_event.h".
> 
> But to have the macro magic work, you need to modify the Makefile to
> have something like:
> 
> CFLAGS_aerdrv_errprint.o = -I$(src)

So I'm guessing that every .c file including the TP should also -I
include the TP definition header wherever it is. Is that agreeable?

Thanks.

-- 
Regards/Gruss,
    Boris.
