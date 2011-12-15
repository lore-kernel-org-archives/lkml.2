Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1LOPoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:44:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41828 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1LOPoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:44:02 -0500
Date: Thu, 15 Dec 2011 15:43:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mike Waychison <mikew@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH 3/4] EFI: Add support for variables longer than 1024
 bytes
Message-ID: <20111215154356.GA10486@srcf.ucam.org>
References: <1323896791-10858-1-git-send-email-mjg@redhat.com>
 <1323896791-10858-4-git-send-email-mjg@redhat.com>
 <CAGTjWtCpt_1h6XMwCFkx1TQnQbagtSuFBejcp6XNr4yhKgNuLg@mail.gmail.com>
 <20111214223950.GA29264@srcf.ucam.org>
 <CAGTjWtARm_OA0qy2Cvtc-rrPFpH2+2QdFw4CvBAo-PJsfX6t6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGTjWtARm_OA0qy2Cvtc-rrPFpH2+2QdFw4CvBAo-PJsfX6t6w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 02:57:51PM -0800, Mike Waychison wrote:
> On Wed, Dec 14, 2011 at 2:39 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Hm. I think that'd only work if we expose a new interface. Writes would
> > be easy enough to handle, but reads still need to work for old apps.
> 
> Well,l we could *not* support returning all the data field for
> datasize > 1024, and simply truncate the field.  We are limited by
> PAGE_SIZE by sysfs here anyway (so we don't really want to have a
> variable size memcpy in efivar_show_raw).

We'll pretty much definitely want to be able to read values > 1024 once 
people start shoving keys in there. The PAGE_SIZE limit is one that I'd 
forgotten about, though.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
