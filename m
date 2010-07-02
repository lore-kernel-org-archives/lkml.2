Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab0GBXNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 19:13:50 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:39832 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756168Ab0GBXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 19:13:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=caP4Bjo+RVO6RbR3hvviHhFXl6m1IGfYoeO75hX7XW+A8pbpuYPBk9YFBUXp9zP+1LKeq2fOyYnZw9UDl5jYFlBzUNlJ69wYSe7G/RjvidpgDhUGok+ZoV+bPkRERal8;
Date: Fri, 2 Jul 2010 16:13:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       lrodriguez@atheros.com, maximlevitsky@gmail.com
Subject: Re: [PATCH] PCI: Default PCIe ASPM control to on and require
 !EMBEDDED to disable
Message-ID: <20100702161346.78896982@virtuousgeek.org>
In-Reply-To: <1277240583-5607-1-git-send-email-mjg@redhat.com>
References: <1277240583-5607-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 17:03:03 -0400
Matthew Garrett <mjg@redhat.com> wrote:

> The CONFIG_PCIEASPM option is confusing and potentially dangerous. ASPM is
> a hardware mediated feature rather than one under direct OS control, and
> even if the config option is disabled the system firmware may have turned
> on ASPM on various bits of hardware. This can cause problems later -
> various hardware that claims to support ASPM does a poor job of it and may
> hang or cause other difficulties. The kernel is able to recognise this in
> many cases and disable the ASPM functionality, but only if CONFIG_PCIEASPM
> is enabled.
> 
> Given that in its default configuration this option will either leave the
> hardware as it was originally or disable hardware functionality that may
> cause problems, it should by default y. The only reason to disable it
> ought to be to reduce code size, so make it dependent on CONFIG_EMBEDDED.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: lrodriguez@atheros.com
> Cc: maximlevitsky@gmail.com
> ---
>  drivers/pci/pcie/Kconfig |   20 ++++++++++++++------
>  1 files changed, 14 insertions(+), 6 deletions(-)
> 

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
