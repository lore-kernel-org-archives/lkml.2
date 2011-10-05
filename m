Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184Ab1JEJX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:23:58 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:52968 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab1JEJX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:23:57 -0400
Date: Wed, 5 Oct 2011 14:53:50 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005092350.GA7485@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004140437.GA28306@redhat.com>
 <20111005071844.GB2235@in.ibm.com>
 <20111005073313.GB13478@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005073313.GB13478@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 09:33:13AM +0200, Borislav Petkov wrote:
> On Wed, Oct 05, 2011 at 12:48:44PM +0530, K.Prasad wrote:
> > On Tue, Oct 04, 2011 at 10:04:37AM -0400, Vivek Goyal wrote:
> > > On Mon, Oct 03, 2011 at 01:02:03PM +0530, K.Prasad wrote:
> > > > There are certain types of crashes induced by faulty hardware in which
> > > > capturing crashing kernel's memory (through kdump) makes no sense (or sometimes
> > > > dangerous).
> > > > 
> > > > A case in point, is unrecoverable memory errors (resulting in fatal machine
> > > > check exceptions) in which reading from the faulty memory location from the
> > > > kexec'ed kernel will cause double fault and system reset (leaving no
> > > > information for the user).
> > > 
> > > Prasad,
> > > 
> > > I am just trying to remember what was wrong with Andi's approach of
> > > disable MCE while copying the dump?
> > >
> > 
> > Hi Vivek,
> > 	The behaviour upon a read operation on an UC memory location is
> > undefined and so we want to avoid it (previously discussed here:
> > http://article.gmane.org/gmane.linux.kernel/1146799). When we disable
> > MCE and copy the dump, we will invariably read the faulty memory
> > location.
> 
> Right, from the message above:
> 
> "- To disable MCE exceptions as done by the patches cited above. However
>   the result of a read operation on corrupted memory is unknown and the
>   system behaviour is undefined. We're unsure if this is a safe thing to
>   do."
> 
> Can you elaborate more on that? Are we talking poisoned memory here or
> undetected and uncorrectable memory errors?
>

It refers to uncorrected memory errors that are not consumed and the
corresponding 'struct page's are marked PG_hwpoison. Typically the SRAO
type errors that are handled in mm/memory-failure.c.

If MCE is enabled, during a kdump, we will deliberately trigger a read
operation over the poisoned memory and make the UCE fatal. It is not
clear what would happen if MCE is disabled in the above case.

Thanks,
K.Prasad

