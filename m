Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1AGTbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:31:55 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51198 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab1AGTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:31:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=rq6WYm9L7q038pCL3zq6lFbMpbH9cpsuw5omatnnITxcS5TIJObUPrC/BclPxlFcKy
         VLc69GTXkriFN1K1CMHWUycyvfDTfeDyhwDSiOgkZrxCPe1xth6W5XfM3cL+ZK6iNoQC
         0OfcHl+0Shy9+YK5+jYwR9ho/pCWU3InsHxCk=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, aospan@netup.ru
Subject: Re: [PATCH 01/18] Altera FPGA firmware download module.
In-Reply-To: <4D1DC2DD.6050400@infradead.org>
References: <201012310726.31851.liplianin@netup.ru> <201012311212.19715.laurent.pinchart@ideasonboard.com> <4D1DBE2A.5080003@infradead.org> <201012311230.51903.laurent.pinchart@ideasonboard.com> <4D1DC2DD.6050400@infradead.org>
User-Agent: Notmuch/0.5-17-g2d1420b (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Jan 2011 14:31:48 -0500
Message-ID: <8739p45x3v.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Fri, 31 Dec 2010 09:47:41 -0200, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Em 31-12-2010 09:30, Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > [snip]
> > 
> > I understand this. However, a complete JTAG state machine in the kernel, plus 
> > an Altera firmware parser, seems to be a lot of code that could live in 
> > userspace.
> 
> Moving it to userspace would mean a kernel driver that would depend on an
> userspace daemon^Wfirmware loader to work. I would NAK such designs.
> 
> The way it is is fine from my POV.

Any furthur comment on this? As I noted, I strongly disagree and would
point out that there is no shortage of precedent for the use of
userspace callbacks for loading of firmware, especially when the process
is as tricky as this.

I also work with Altera FPGAs and have a strong interest in making this
work yet from my perspective it seems pretty clear that the best way
forward both for both maintainability and useability is to keep
this code in user-space. There is absolutely no reason why this code
_must_ be in the kernel and punting it out to userspace only requires
a udev rule.

Placing this functionality in userspace results in a massive duplication
of code, as there are already a number of functional user-space JTAG
implementations.

> > If I understand it correctly the driver assumes the firmware is in an Altera 
> > proprietary format. If we really want JTAG code in the kernel we should at 
> > least split the file parser and the TAP access code.
> > 
> 
> Agreed, but I don't think this would be a good reason to block the code merge
> for .38.
> 
Sure, but there should be agreement that a kernel-mode JTAG state
machine really is the best way forward (i.e. necessary for effective
firmware upload) before we commit to carry this code around forever.

- Ben
