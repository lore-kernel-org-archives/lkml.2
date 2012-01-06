Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab2AFMA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:00:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab2AFMA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:00:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drivers: misc: Remove MISC_DEVICES config option
Date: Fri, 6 Jan 2012 12:00:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Fabio Estevam <festevam@gmail.com>, netdev@vger.kernel.org,
        gwingerde@gmail.com, larry.finger@lwfinger.net, davem@davemloft.net,
        bhutchings@solarflare.com, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1325796541-11402-1-git-send-email-festevam@gmail.com> <CAOMZO5BQhcxViN3KnjhzF9hL1w04egkmb9njc7sDUB0GFdgBog@mail.gmail.com> <20120106050355.GA7633@kroah.com>
In-Reply-To: <20120106050355.GA7633@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201201061200.44183.arnd@arndb.de>
X-Provags-ID: V02:K0:4tsC472mYIpsShGGLVA2vWgQYgFC5u3b6Bz2zf24zaD
 T9A+vOVd/tNUk3Nuy3Qt9FPt7HEjAJBL0sL95QKN5i61/s45qY
 JLGE62+wj0P0sw3HIsRapOcjDxxriAt7k1PGOVcaLyE09jTNgo
 5eIAeZ1UnpIwpvEj7dQ1DkfOe1HnbPIW+/29wLfJg5DH+dA1yE
 bEY4ciBKOr2J51Zd8l9ymstuQvtHM7tT+f9ExUL6RxoxKrNZCP
 cseFdln3LWnTlg88CQhdGmiRWdBMrsxChAktVR7fCBQk/Jy5z9
 dEDiJJnBbLFgLyGJDo9gQzgPMJrxtHQfH+M/XXGOj7jv/9nnlc
 D9wJAUkTTcEIAqqp04/k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 January 2012, Greg KH wrote:
> On Thu, Jan 05, 2012 at 11:18:28PM -0200, Fabio Estevam wrote:
> > On Thu, Jan 5, 2012 at 8:39 PM, Greg KH <greg@kroah.com> wrote:
> > 
> > > Are you sure that this isn't getting confused with the
> > > drivers/char/misc.c interface instead of the "throw a bunch of randome
> > > drivers into drivers/misc/" issue?
> > 
> > Sorry, I am not aware of this issue.
> > 
> > > Why would anything ever want to select MISC_DEVICES?  What happens if
> > > you just remove that select line from the Kconfig?
> > 
> > Yes, I don´t understand the point of allowing the selection MISC_DEVICES.
> > 
> > IMHO it is potential for causing dependency issues.
> 
> Then remove that selection.  Nothing should be depending on a misc
> driver, if it is, then that implies that this is more than just a "misc"
> driver, and it should be moved elsewhere.

I think that is true for the majority of stuff we have under drivers/misc
anyway. I had done the same patch that Fabio sent a couple of months ago
but then forgot about it, so here is a wholehearted

Acked-by: Arnd Bergmann <arnd@arndb.de>

for the new patch. It fixes a real problem, and we applied a similar patch
in drivers/mfd as 8a0a8e8e already. We probably still want to find a better
home for drivers that frequently get selected by other subsystems as you
said, but that is an independent issue. I don't see why anyone would
need a way to disable all MISC drivers at once, when the only thing that
(in theory) connects them is that they are all different from everything
else.

	Arnd
