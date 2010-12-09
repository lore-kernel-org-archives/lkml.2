Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0LIP13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:27:29 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36423 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab0LIP11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:27:27 -0500
Date: Thu, 9 Dec 2010 15:27:06 +0000
From: Matthew Garrett <mjg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Edouard Gomez <ed.gomez@free.fr>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Thomas Backlund <tmb@mandriva.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Dell Precision WorkStation 690 reboot quirk
Message-ID: <20101209152706.GB7273@srcf.ucam.org>
References: <4d8b4b3a1d3c6034b868.1291822674@egomez.in.mobiclip.com> <20101209151633.GA7273@srcf.ucam.org> <4D00F390.6020609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D00F390.6020609@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 07:19:44AM -0800, H. Peter Anvin wrote:
> On 12/09/2010 07:16 AM, Matthew Garrett wrote:
> > My testing suggests that Windows never uses the BIOS-style reboot 
> > approach, so this seems wrong. Does reboot=acpi work for you?
> 
> We have talked about switching to reboot=acpi by default for machines
> newer than <some date>... this would be good to do.

The majority of systems with valid ACPI reboot vectors appear to just be 
pointing at the PCI reset port, which makes sense. My testing suggests 
that Windows calls the ACPI reboot vector, then tries to use the i8042, 
then tries the ACPI reboot vector again and finally tries the i8042 
again before giving up and spinning. I'll recheck this behaviour today 
and then send a patch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
