Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934957Ab0GOXIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:08:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49624 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383Ab0GOXIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:08:37 -0400
Date: Fri, 16 Jul 2010 00:08:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pedro Ribeiro <pedrib@gmail.com>, eusou15@yahoo.com,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [ibm-acpi-devel] [PATCH] Remove 9 second reboot delay on
	Lenovo T400/T500
Message-ID: <20100715230825.GA31651@srcf.ucam.org>
References: <4C3DCAA4.9050602@gmail.com> <20100714143625.GA30721@srcf.ucam.org> <20100715223149.GC27512@khazad-dum.debian.net> <20100715225022.GA31377@srcf.ucam.org> <20100715230023.GE27512@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715230023.GE27512@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 08:00:23PM -0300, Henrique de Moraes Holschuh wrote:

> Do you want to escalate this to Lenovo?  I need a clear and consise
> description of the problem and the boxes we know to be affected.

Well, right now we're not doing precisely what Windows does. The other 
possibility is that when the keyboard controller write triggers some SMM 
code, it makes an assumption about some piece of hardware state that 
isn't true and loops for a while to see if it changes. If we knew what 
that was then we could ensure that we're performing the same state 
change on our way down to reboot.

One thing that would be worth checking is whether performing the 
keyboard controller writes from userspace with a minimal kernel and 
init=/bin/bash shows the 9-second pause or not - and then, ideally, see 
whether the same is also true under DOS.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
