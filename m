Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab1DHTvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:51:20 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:52208 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757776Ab1DHTvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:51:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tiedUg/YSRg0uJIFd0l9hiOLai8CRbg8AnjQe0XCl28kMQXszJRZUXfX9lu2o3IXJuuJ4OGbo5lbUELnR2KI3BEwLGgLQW7XXTXZHnREq5YcqAO/U36XEpXM97EzwHDH;
Date: Fri, 8 Apr 2011 12:51:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: <linux-kbuild@vger.kernel.org>, <mingo@elte.hu>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] move some .pci_fixup_* sections into .init
Message-ID: <20110408125110.52aa90c4@jbarnes-desktop>
In-Reply-To: <4D5262C30200007800030F9C@vpn.id2.novell.com>
References: <4D5262C30200007800030F9C@vpn.id2.novell.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Feb 2011 08:47:47 +0000
"Jan Beulich" <JBeulich@novell.com> wrote:

> .pci_fixup_final is only used from .init.text, and hence can (along
> with the respective handler functions) reside in .init.*.
> 
> Several other .pci_fixup_* sections are needed only during boot and
> suspend/resume, and can therefore be moved into .init.* if
> !CONFIG_PM_OPS.
> 
> While generally section mismatch checking is being turned on by this
> patch for all of .pci_fixup_*, for .pci_fixup_header it is being
> suppressed for the moment as it caused way too much fallout.
> Theoretically, all respective handlers must get their __init/__devinit
> removed, as this gets processed from a non-__init, non-__devinit
> function.
> 
> This also adds a previously missing comma in the definition of
> ALL_INIT_DATA_SECTIONS.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>

This didn't apply for me, but I'd be happy to take the PCI parts, can
you re-send against my linux-next branch (assuming it's not already
applied to some other tree).

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
