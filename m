Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1JEP0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:26:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757963Ab1JEP0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:26:00 -0400
Date: Wed, 5 Oct 2011 11:25:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111005152537.GB30146@redhat.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
 <20111004140437.GA28306@redhat.com>
 <20111005071844.GB2235@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005071844.GB2235@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 12:48:44PM +0530, K.Prasad wrote:
> On Tue, Oct 04, 2011 at 10:04:37AM -0400, Vivek Goyal wrote:
> > On Mon, Oct 03, 2011 at 01:02:03PM +0530, K.Prasad wrote:
> > > There are certain types of crashes induced by faulty hardware in which
> > > capturing crashing kernel's memory (through kdump) makes no sense (or sometimes
> > > dangerous).
> > > 
> > > A case in point, is unrecoverable memory errors (resulting in fatal machine
> > > check exceptions) in which reading from the faulty memory location from the
> > > kexec'ed kernel will cause double fault and system reset (leaving no
> > > information for the user).
> > 
> > Prasad,
> > 
> > I am just trying to remember what was wrong with Andi's approach of
> > disable MCE while copying the dump?
> >
> 
> Hi Vivek,
> 	The behaviour upon a read operation on an UC memory location is
> undefined and so we want to avoid it (previously discussed here:
> http://article.gmane.org/gmane.linux.kernel/1146799).

> When we disable MCE and copy the dump, we will invariably read the faulty
> memory location.

And how that is worse then not capturing a dump at all? Anyway, you said
that in case of MCE vmcore is of no use and we don't want to capture it.

Thanks
Vivek
