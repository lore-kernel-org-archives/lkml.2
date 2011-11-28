Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1K1O1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:27:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab1K1O1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:27:13 -0500
Date: Mon, 28 Nov 2011 09:26:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Dave Anderson <anderson@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 1/2][slimdump] Append CRASH_REASON to VMCOREINFO
 elf-note
Message-ID: <20111128142652.GB20758@redhat.com>
References: <20111121101157.GA10194@in.ibm.com>
 <36c0c64c-9ccb-44a0-a81c-1071604cbdec@zmail15.collab.prod.int.phx2.redhat.com>
 <20111123173930.GC2515@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123173930.GC2515@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:09:31PM +0530, K.Prasad wrote:
> On Mon, Nov 21, 2011 at 10:19:31AM -0500, Dave Anderson wrote:
> > 
> > 
> > ----- Original Message -----
> > > Allow various crash paths to append the reason of crash into the
> > > VMCOREINFO elf-note through the field CRASH_REASON. We also make the
> > > fatal machine check exceptions append "PANIC_MCE" as the crash
> > > reason.  This string will be recognised by upstream tools like makedumpfile and
> > > crash to generate slimdump.
> > 
> > I don't understand -- how could "various paths" append a reason?
> > The patch below seems to return "PANIC_MCE" for every x86 crash.
> > What am I missing?
> > 
> > Dave
> > 
> 
> Yes, presently it can only be "PANIC_MCE" for MCE crashes in x86 (not
> for every crash though).
> 
> With increased usage, we should move this code to a generic location and
> let each of these crash paths return a string to be appended. In fact it
> doesn't have to be a string for CRASH_REASON but just an encoding of the
> various crash types into numbers. User-space tools could then do a lookup
> for getting the right crash string.

Probably string is a better idea? Where do we do lookup to find out what
maps to what? This would require kernel exporting this info in a header
and then comes the issue of having same kernel version info. Or the issue
of analyzing kernel dumps on the same machine.

Storing a string will atleast help that one does not have to worry about
mapping error code. makedumpfile shall have to grep for exact same string
though.

Thanks
Vivek
