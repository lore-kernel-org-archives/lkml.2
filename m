Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab1LNW5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 17:57:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41244 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346Ab1LNW5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 17:57:32 -0500
Date: Wed, 14 Dec 2011 22:57:28 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Waychison <mikew@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024
 bytes
Message-ID: <20111214225728.GA29582@srcf.ucam.org>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
 <1323896791-10858-4-git-send-email-mjg@redhat.com>
 <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com>
 <20111214223950.GA29264@srcf.ucam.org>
 <4EE926D2.3030803@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE926D2.3030803@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 02:44:34PM -0800, H. Peter Anvin wrote:
> On 12/14/2011 02:39 PM, Matthew Garrett wrote:
> >> What are your thoughts on _not_ wrapping efi_variable with
> >> extended_efi_variable, and instead just using a
> >> "internal_efi_variable" structure that we copy stuff into/outof.  I
> >> think that would make the memory management for dealing with the
> >> different sizes a lot easier to follow.
> > 
> > Hm. I think that'd only work if we expose a new interface. Writes would 
> > be easy enough to handle, but reads still need to work for old apps.
> > 
> 
> Would making the old ABI readonly and add a new write interface resolve
> the problem with compat mode?

Yes, but we'd break existing userspace.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
