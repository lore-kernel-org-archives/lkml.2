Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0J0RoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:44:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59116 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0J0RoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:44:22 -0400
Date: Wed, 27 Oct 2010 19:44:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Ian Campbell <ian.campbell@citrix.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
Message-ID: <20101027174417.GA19194@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Ian Campbell <ian.campbell@citrix.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
 <20101027104020.GA16954@a1.tnic>
 <4CC85839.4000507@goop.org>
 <4CC85EE6.7030608@linux.intel.com>
 <4CC861F9.8080200@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CC861F9.8080200@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 10:31:37AM -0700, Jeremy Fitzhardinge wrote:
> > Xen shouldn't have any users of this, since it's used for low-level
> > operations like SMP bootstrap, suspend to RAM, reboot and low-level
> > BIOS functionality.
> >
> Right, but it is being called smack in the middle of setup_arch().  It
> looks like they could be hidden away in
> native_pagetable_setup_start/done though.

I think I can put the second sync-back clone_pgd_range in
native_pagetable_setup_done but the first one needs to take place right
at the beginning of setup_arch() because a lot of code in-between relies
on swapper_pg_dir containing proper entries.

Just to make sure I understand you correctly: best it would be for xen
to not have the copy_pgd_range() calls in setup_arch, correct?

-- 
Regards/Gruss,
Boris.
