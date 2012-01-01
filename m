Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2AAMW1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 07:22:27 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:39274 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2AAMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 07:22:25 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Sun, 1 Jan 2012 13:22:34 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <Pine.LNX.4.44L0.1112312033240.28510-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1112312033240.28510-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201011322.34483.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 1. Januar 2012, 03:21:45 schrieb Alan Stern:
> On Sat, 31 Dec 2011, Oliver Neukum wrote:

> > We are definitely going through do_unbind_rebind(). But I don't think
> > it matters why we got there. We seem to be calling probe() too early.
> > And we need to guarantee that a driver can request firmware in probe()
> > 
> > So something has changed in the resume code path further up.
> 
> For at least a year and a half, it has been true that rebinding takes

Yes, so I don't understand why we haven't been hitting this issue
all that time.

> place during the complete phase of system resume.  Clearly that is too 
> early to load firmware.  When do you think we should do it instead?

I think we ought to delay until right after user space is unfrozen.
The devices are gone anyway, so we lose nothing but have the ability
to call helpers.
 
> And how should we keep track of which interfaces need rebinding?

I guess this calls for a brute force approach. We can kick khubd and have
it walk all busses checking for  needs_binding.

> P.S.: Oliver, it looks like there's a bunch of dead code in
> usb_suspend_interface() and usb_resume_interface().  I don't see how
> either one can be executed with a driver that doesn't have both suspend
> and resume methods.  Such cases should be filtered out when
> usb_suspend() calls do_unbind_rebind().  The only odd thing that can
> happen is when a driver doesn't support reset-resume.  Do you agree?

I agree.

	Regards
		Oliver
