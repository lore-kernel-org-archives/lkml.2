Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894Ab1LPAHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:07:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab1LPAHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:07:41 -0500
Date: Thu, 15 Dec 2011 16:07:16 -0800
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>
Subject: Re: [GIT PULL] ibft fix for 3.2-rc6
Message-ID: <20111216000716.GA14822@suse.de>
References: <20111215210538.GA12248@konrad-lan>
 <CAE9FiQXFgOU3c9Ej-B_sZfhs5sRN87xE93BtZoU2K=M6=_O9YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXFgOU3c9Ej-B_sZfhs5sRN87xE93BtZoU2K=M6=_O9YA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 03:15:55PM -0800, Yinghai Lu wrote:
> On Thu, Dec 15, 2011 at 1:05 PM, Konrad Rzeszutek Wilk
> <konrad@darnok.org> wrote:
> > Hey Linus,
> >
> > Please git pull the following branch:
> >
> >  git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft.git linux-next
> >
> > which has a fix to make the ACPI table called 'iSCSI Boot Format Table'
> > (IBFT) be found by the iscsi-ibft driver when booting under UEFI.
> >
> > The functionality to grab the APCI IBFT was added some time ago, but we
> > did not have the UEFI box to test it. Now that it has been tested it was
> > uncovered that the ACPI parser code was run way to early - so it did not
> > parse the iBFT table at all. This patch fixes it by doing the ACPI parsing later.
> > The legacy iBFT searching is not affected (which is to scan 640K->1MB
> > for the iBFT signature) and works correctly.
> >
> > Please pull!
> >
> > Yinghai Lu (1):
> >      ibft: Fix finding IBFT ACPI table on UEFI
> >
> >  drivers/firmware/iscsi_ibft.c      |   42 ++++++++++++++++++++++++++++++++++-
> >  drivers/firmware/iscsi_ibft_find.c |   26 +--------------------
> >  2 files changed, 42 insertions(+), 26 deletions(-)
> 
> Greg,
> 
> Can you please put this one into stable
> 
> 	935a9fee51c945b8942be2d7b4bae069167b4886
> 
> actually,  even still need to apply to 2.6.32 stable

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>


That being said, I've queued this up for the 3.0 and 3.1 stable releases
now.

> but commit description could be some different:

Sorry, if you want something different, you are going to have to send me
the whole patch to stable@vger.kernel.org.

> for 2.6.32, and kernel before memblock is supported in x86:
> Even we call reserve_ibft_region() in x86 setup_arch() some late, but
> it still in early stage.
> at that time, acpi table is mapped for temporal use and will be
> unmapped after handler is called
> So handler should not store remapped address for late use.
> 
> only after init_main()/early_acpi_init(), we can store those remapped
> address for acpi tables in handles

I have no idea what you are referring to here.

The patch as-is does not apply to 2.6.32, so I can't apply it there.  If
you want it applied there, please provide the backport to the above
mentioned email address.

thanks,

greg k-h
