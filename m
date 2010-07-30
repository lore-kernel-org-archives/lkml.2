Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0G3Qmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 12:42:53 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:59348 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753061Ab0G3Qmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 12:42:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=at/wi+AqCMRTohAscARdo/+Aviv48cWq8ZG/bPPzeoldXjDBC3TMdcpIopeO9FfxjJy3+u9xqKLe4fl+QfwHA6r8klt41iMdnIYl615xOVRx+a8sOC5JhQaZTAXRb1DM;
Date: Fri, 30 Jul 2010 09:42:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: MSI: Restore read_msi_msg_desc(); add
 get_cached_msi_msg_desc()
Message-ID: <20100730094247.05cb070e@virtuousgeek.org>
In-Reply-To: <1279893388.2089.9.camel@achroite.uk.solarflarecom.com>
References: <20100723102202.871a3131.sfr@canb.auug.org.au>
	<1279847985.4883.391.camel@localhost>
	<1279850740.6381.19.camel@concordia>
	<1279893388.2089.9.camel@achroite.uk.solarflarecom.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 14:56:28 +0100
Ben Hutchings <bhutchings@solarflare.com> wrote:

> commit 2ca1af9aa3285c6a5f103ed31ad09f7399fc65d7 "PCI: MSI: Remove
> unsafe and unnecessary hardware access" changed read_msi_msg_desc() to
> return the last MSI message written instead of reading it from the
> device, since it may be called while the device is in a reduced
> power state.
> 
> However, the pSeries platform code really does need to read messages
> from the device, since they are initially written by firmware.
> Therefore:
> - Restore the previous behaviour of read_msi_msg_desc()
> - Add new functions get_cached_msi_msg{,_desc}() which return the
>   last MSI message written
> - Use the new functions where appropriate
> 
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> ---
> Compile-tested only.
> 

Applied to linux-next with Michael's ack, thanks.  I hope it actually
works, I didn't see a tested-by!

-- 
Jesse Barnes, Intel Open Source Technology Center
