Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1EaRBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:01:03 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:51341 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757303Ab1EaRBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:01:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=RkbuOcNBKs26m411nlUhjSfdb5tyALCh0xVjnXXtOerXsWyr8Bd7EtCotaQeD0NpvOywKPAwfY9u0ZwuXzecplLdBPqltNdE/PTNF2SP8n8FcflMnQvptZ7VHvwUoYXO;
Date: Tue, 31 May 2011 10:00:40 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-pci@vger.kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Subject: Re: [Xen-devel] Re: [PATCH v6] xen pci backend driver.
Message-ID: <20110531100040.60ade056@jbarnes-desktop>
In-Reply-To: <20110527152220.GA10031@dumpdata.com>
References: <1303333640-5994-1-git-send-email-konrad.wilk@oracle.com>
	<20110425115850.48b7d254@jbarnes-desktop>
	<20110527152220.GA10031@dumpdata.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011 11:22:20 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Mon, Apr 25, 2011 at 11:58:50AM -0700, Jesse Barnes wrote:
> > On Wed, 20 Apr 2011 17:07:19 -0400
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> > > The following patch implements the Xen pci backend for upstream Linux.
> > > This is the host side counterpart to the frontend driver in
> > > drivers/pci/xen-pcifront.c. The PV protocol is also implemented by
> > > frontend drivers in other OSes too, such as the BSDs.
> > > 
> > > This driver has a long history as an out of tree driver but I am
> > > submitting it here as a single monolithic patch to aid review. Once it
> > > has been reviewed and is considered suitable for merging can we perhaps
> > > consider merging the equivalent git branch which maintains much of
> > > history?
> > 
> > It looks pretty clean at first glance (though 128k worth of patch isn't
> > an ideal way to split it).
> > 
> > But maybe the back end belongs in arch/x86/xen as it's really a arch
> > specific PCI implementation at heart?  I don't want to be a bottleneck
> > for any Xen specific PCI patches in the future, and other arches have a
> > similar split (though not always with an ideal core vs arch split).
> 
> Jesse,
> 
> Xen has a drivers/xen directory. In the past we have put some of the
> "backends" in there, such as the SWIOTLB one. Perhaps some of it (or all?)
> of this driver should go in there? If you are OK with this I can do it
> that way and start chasing folks to review this driver?

Yeah, I'm fine with that.  Each arch typically has a chunk of PCI code
under arch/ anyway (some more than others), so doing it that way is ok
with me.
 
> > Figuring out some way to preserve the git history is probably a good
> > idea, assuming it's not too much of a mess.  If it is, a more
> 
> I tried to keep it clean.. Most of the stuff is from me thought so I might
> as well just squash it in one.

Yeah that's up to you; presumably you just want to preserve the useful
parts of the history, or maybe just make the initial changelog big
enough to include all the important bits you've learned over the
years. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
