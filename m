Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab2JDNbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:31:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab2JDNbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:31:00 -0400
Date: Thu, 4 Oct 2012 09:30:51 -0400
From: Peter Jones <pjones@redhat.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, glin@suse.com,
        "Lee, Chun-Yi" <jlee@suse.com>, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] efi: add efivars kobject to efi sysfs folder
Message-ID: <20121004133050.GA4133@eddie.install.bos.redhat.com>
References: <1349317486-30006-1-git-send-email-jlee@suse.com>
 <1349340875.15966.18.camel@mfleming-mobl1.ger.corp.intel.com>
 <506D5220.8080307@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <506D5220.8080307@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 05:08:48PM +0800, Jeremy Kerr wrote:
> Hi Matt,
> 
> >Jeremy, did you want to pick this up as part of your series?
> 
> I have this in my series, yes. I'm just working on the authenticated
> delete code, then will send out the next revision.
> 
> Speaking of which - Peter: I've realised that doing a GetVariable()
> after the SetVariable is a much cleaner way of checking whether we
> need to drop the inode after an authenticated delete.
> 
> Because the inode's size may not be simply updated by the write(),
> we should probably be doing a GetVariable() after an APPEND_WRITE,
> to read the new size. Rather than having a separate (and quite
> complex) code path to check for the delete case, we may as well use
> the same logic to determine if the variable has been deleted.

Yeah, this is fine.

> >Actually, shouldn't the new filesystem be called "efivarfs", or "efifs"
> >to make it more explicit that it is a filesystem?
> 
> I'm not too fussed about the name, but +1 for efivarfs.

I like efivarfs for the name, as well.

> >We also need something in Documentation/filesystems/ describing the old
> >EFI variable method, why it's no longer any good, and why the new
> >filesystem is favoured. Does anybody have anything to add to the
> >following?
> 
> Looks good to me. We can always elaborate later, if necessary.

Yep.

-- 
        Peter
