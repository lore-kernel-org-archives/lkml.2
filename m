Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2JZQr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:47:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:59073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2JZQrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:47:55 -0400
Date: Fri, 26 Oct 2012 09:47:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guillaume Juan <guillaume.juan@sagemcom.com>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n_gsm: prevent crash due to dereferencing NULL gsm->tty
Message-ID: <20121026164752.GA26968@kroah.com>
References: <26026_1351239109_508A45C4_26026_63_1_508A45C1.3010407@sagemcom.com>
 <20121026152052.GA15840@kroah.com>
 <3252_1351269266_508ABB91_3252_975_1_508ABB8F.5040906@sagemcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3252_1351269266_508ABB91_3252_975_1_508ABB8F.5040906@sagemcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 06:34:23PM +0200, Guillaume Juan wrote:
> Le 26/10/2012 17:20, Greg Kroah-Hartman a écrit :
> 
> > On Fri, Oct 26, 2012 at 10:11:45AM +0200, Guillaume Juan wrote:
> >> From: Guillaume Juan <guillaume.juan@sagemcom.com>
> >>
> >> If gsm->tty happens to be NULL in gsmld_output, avoid crashing the kernel (the crash is replaced by a warning dump).
> > 
> > How can ->tty be NULL here?
> > 
> 
> I had some crashes and identified 2 causes: this is what I tried to explain in the 2nd part of the changelog ("Prevent at earlier level such situation: [...]"). Basically it is because the T1 and T2 timers may be rearmed while gsm_cleanup_mux executes (T1 is rearmed by gsmtty_hangup called by gsm_cleanup_mux itself via gsm_dlci_release, whereas T2 may be rearmed by a concurrent call to gsmtty_close).
> 
> My patch is intended to remove theses causes, but I thought safer to avoid the crash in gsmld_output if ever there are other causes remaining. Do you mean I should let the crash happen for these unproven cases?

If you leave it, and it happens, then you know you didn't really fix the
real problem :)

> >> " This e-mail and any attached documents may contain confidential or
> >> proprietary information. If you are not the intended recipient, you are
> >> notified that any dissemination, copying of this e-mail and any attachments
> >> thereto or use of their contents by any means whatsoever is strictly
> >> prohibited. If you have received this e-mail in error, please advise the
> >> sender immediately and delete this e-mail and all attached documents
> >> from your computer system."
> >> #
> > 
> > Because of that footer, I am not allowed to accept this patch at all.
> > Please remove it and resend.
> 
> Argh. I'm afraid I don't know how to remove it, since it seems added automatically by my company mail server. I probably will have to struggle with the admins. But since you ARE the "intended recipient" and the content is NOT "confidential or proprietary", does it really forbid you to use the patch?

Yes it does, it goes against the "Signed-off-by:" line in the patch, and
because of that, I am not allowed to accept it.  If you wish to do
kernel development, either get your email admins to fix it, or use an
external email account (sadly the only solution for a lot of people.)
If you use an external account, be sure you properly set the "From:"
line in the patch to your properly account, see the file,
Documentation/SubmittingPatches for details.

thanks,

greg k-h
