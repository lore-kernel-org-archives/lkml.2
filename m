Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1KWRnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:43:00 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:58925 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1KWRm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:42:59 -0500
Date: Wed, 23 Nov 2011 23:12:25 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Dave Anderson <anderson@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 1/2][slimdump] Append CRASH_REASON to VMCOREINFO
 elf-note
Message-ID: <20111123174225.GA5184@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111121101157.GA10194@in.ibm.com>
 <36c0c64c-9ccb-44a0-a81c-1071604cbdec@zmail15.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36c0c64c-9ccb-44a0-a81c-1071604cbdec@zmail15.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11112317-1524-0000-0000-000000436069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:19:31AM -0500, Dave Anderson wrote:
> 
> 
> ----- Original Message -----
> > Allow various crash paths to append the reason of crash into the
> > VMCOREINFO elf-note through the field CRASH_REASON. We also make the
> > fatal machine check exceptions append "PANIC_MCE" as the crash
> > reason.  This string will be recognised by upstream tools like makedumpfile and
> > crash to generate slimdump.
> 
> I don't understand -- how could "various paths" append a reason?
> The patch below seems to return "PANIC_MCE" for every x86 crash.
> What am I missing?
> 
> Dave
>

Yes, presently it can only be "PANIC_MCE" for MCE crashes in x86 (not
for every crash though).

With increased usage, we should move this code to a generic location and
let each of these crash paths return a string to be appended. In fact it
doesn't have to be a string for CRASH_REASON but just an encoding of the
various crash types into numbers. User-space tools could then do a
lookup for getting the right crash string.

Thanks,
K.Prasad
 

