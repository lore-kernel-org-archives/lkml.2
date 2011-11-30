Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab1K3RP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:15:59 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:56961 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab1K3RP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:15:57 -0500
Date: Wed, 30 Nov 2011 22:45:24 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [RFC Patch 0/2] Slimdump framework using CRASH_REASON - v2
Message-ID: <20111130171524.GA2632@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111121095405.GA2289@in.ibm.com>
 <20111121151727.GF313@redhat.com>
 <20111123173318.GB2515@in.ibm.com>
 <20111128142402.GA20758@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128142402.GA20758@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11113017-8936-0000-0000-0000053A875A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 09:24:02AM -0500, Vivek Goyal wrote:
> On Wed, Nov 23, 2011 at 11:03:18PM +0530, K.Prasad wrote:
> > On Mon, Nov 21, 2011 at 10:17:27AM -0500, Vivek Goyal wrote:
> > > On Mon, Nov 21, 2011 at 03:24:05PM +0530, K.Prasad wrote:
[snipped]
> > 
> > The kernel message buffers can be obtained by using the --dump-dmesg
> > option of makedumpfile but again that's risky. We wouldn't know if it'll
> > cause access to the faulty memory (which is how the previous method of having
> > a new elf-notes in a pristine location is much safer).
> > 
> > The method in this patch is quite primitive in that informs the user
> > nothing more than a one-line cause of crash. One should take help from other
> > tools (such as service processor/firmware/ACPI logs, or previous corrected
> > error logs) to infer the location of bad memory.
> 
> And how does one get to firmware/ACPI logs? Many system don't have service
> processor also.
> 
> I think extracting kernel buffers by default in case of MCE is reasonable.
> This should allow somebody to figure out some MCE related information.
> 
> You might want to modify makedumpfile so that it does not try to access
> pages marked poisoned.
>

I'm not sure how easy or difficult it would be to skip hw-poisoned pages
from user-space i.e. makedumpfile. I'll start working on the relevant
changes though, and keep the community posted with the patches.

Thanks,
K.Prasad

