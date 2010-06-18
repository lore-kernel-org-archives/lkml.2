Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0FRMG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:06:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59252 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761085Ab0FRMG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tTcISa6VXXZhTjsDXCwJrasWDl5ZvymC9YeXGbyiUu640gApfLKwFfBwLFfH0OgtrJ
         OuVuortNFpf5K8EYbzfcluPI481IddIY4dDtnbpwCYVirymbxnCJ9v5EYolpGrWREVGO
         KnEIJE7Q/f8H/Q5/OpFEEuUk/79IIJ7ZszvUw=
Subject: Re: [PATCH] pci: Don't enable aspm before drivers have had a
 chance to veto it
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Matthew Garrett <mjg@redhat.com>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1276113907-22432-1-git-send-email-mjg@redhat.com>
References: <1276113907-22432-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 15:06:51 +0300
Message-ID: <1276862811.19918.10.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 16:05 -0400, Matthew Garrett wrote: 
> The aspm code will currently set the configured aspm policy before drivers
> have had an opportunity to indicate that their hardware doesn't support it.
> Unfortunately, putting some hardware in L0 or L1 can result in the hardware
> no longer responding to any requests, even after aspm is disabled. It makes
> more sense to leave aspm policy at the BIOS defaults at initial setup time,
> reconfiguring it after pci_enable_device() is called. This allows the
> driver to blacklist individual devices beforehand.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---

Hi,

I recently discovered that my aspire one wireless troubles (card just
dies after a while) are caused by ASPM L0S state.
The device (AR5001) seems to have a hardware bug, and it also disables
L0S in windows driver.

Unfortenuly BIOS (news at 11) enables L0S.

Its easy to disable ASPM from driver. It just a matter of calling
pci_disable_link_state.

However, that depends on CONFIG_PCIEASPM.

How about making pci_disable_link_state always available or even better,
just make CONFIG_PCIEASPM unconditional?


Btw, this is my last linux problem that had slim chances to be solved.
The other one was s2ram hang on my primary notebook.

This just shows that in linux everyone helps each other.

I fixed almost impossible s2ram problem on my notebook.
Jussi Kivilinna fixed almost impossible to solve problem on my aspire
one.


Best regards,
Maxim Levitsky


