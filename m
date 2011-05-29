Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab1E2G6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 02:58:36 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49883 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750916Ab1E2G6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 02:58:34 -0400
Date: Sun, 29 May 2011 08:58:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Safford <safford@watson.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH v5 00/21] EVM
Message-ID: <20110529065818.GA2122@elf.ucw.cz>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
 <20110518172552.6d482c7a.akpm@linux-foundation.org>
 <20110526060842.GA13933@localhost.ucw.cz>
 <4DDE80FE.7010005@schaufler-ca.com>
 <1306433514.24986.26.camel@localhost.localdomain>
 <20110526183849.GA4563@ucw.cz>
 <1306439347.3092.89.camel@localhost.localdomain>
 <20110526201725.GC15959@elf.ucw.cz>
 <1306518351.24986.102.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306518351.24986.102.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2011-05-27 13:45:51, David Safford wrote:
> On Thu, 2011-05-26 at 22:17 +0200, Pavel Machek wrote:
> 
> > I suggest you explain the patchset in the emails, then? Everyone here
> > seems to be confused... Attack it protects against, and what kind of
> > hardware is needed for the protection to be effective?
> 
> The white paper is over 15 pages, and it barely scratches the surface.
> Every customer has different security threat models and requirements.
> Discussing this in general on the mailing list is really hard.
> 
> So let's try to simplify this just down to digital signatures in
> the cellphone environment, as you state:

Good.

> > Because AFAICT, file signatures, as proposed, are only useful for
> > locking down my cellphone against myself. (That's -- evil).
> 
> The proposed digital signatures can enforce authenticity of a file's 
> data (IMA-Appraisal with Digital Signature), and of a file's metadata
> (EVM with Digital Signature). For most users, enforcing authenticity
> of files is a good thing - a user knows that they are running authentic
> software signed by their phone manufacturer, and not malicious files
> that they, or someone else installed. In this threat model, EVM is 

Ok, so lets talk about smartphone, similar to my HTC Dream (developer
version, unlocked bootloader, flashable from kernel (*)).

Yes, I could install the crazy EVM/IMA infastructure to prevent
applications modifying selected files.

But... I could just do chattr +i on selected files, I do not need
fancy EVM/IMA for that.

> Blocking signature verification would serve only to punish Linux 
> users who care about the authenticity of their files, while doing 
> _nothing_ to stop manufacturers from locking their bootloaders.

chattr already protects authenticity of my files, as do standard unix
permissions.

So... where's the difference?

								Pavel
(*) but it does not change anything.

True; determined attacker could steal my cellphone, open it up,
desolder the flash, and change attributes of the filesystem.

But... the same determined attacker can also replace
bootloader&kernel&filesystem -- that is in the same flash! -- with
unlocked versions. So the argumentation is the same for locked down
phone.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
