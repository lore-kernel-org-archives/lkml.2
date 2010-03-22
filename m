Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab0CVQcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:32:12 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:36034 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755054Ab0CVQcJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:32:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jKFB77cq/ZBJjpCKHtGzBtiJ9aW1ofla1qmpyDSWB+8tvxLqGlFcgrJyWhRU11PrVbrxHGZKxnTJcn4k+CKfmxj4b9snqn2vXoP8l72LA4qB7zk/y9FFKSxwyMsnXc9N;
Date: Mon, 22 Mar 2010 09:32:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-pci@vger.kernel.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI quirks: RS780/RS880: work around missing MSI 
 initialization
Message-ID: <20100322093205.5edc3f6a@jbarnes-piketon>
In-Reply-To: <a728f9f91003220928t4655180djabe16e36c3389a05@mail.gmail.com>
References: <4BA72FC0.6060002@ladisch.de>
	<a728f9f91003220928t4655180djabe16e36c3389a05@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010 12:28:00 -0400
Alex Deucher <alexdeucher@gmail.com> wrote:

> On Mon, Mar 22, 2010 at 4:52 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> > AMD says in section 2.5.4 (GFX MSI Enable) of #43291 (AMD 780G Family
> > Register Programming Requirements):
> >
> >  The SBIOS must enable internal graphics MSI capability in GCCFG by
> >  setting the following: NBCFG.NB_CNTL.STRAP_MSI_ENABLE='1'
> >
> > Quite a few BIOS writers misinterpret this sentence and think that
> > enabling MSI is an optional feature.  However, clearing that bit just
> > prevents delivery of MSI messages but does not remove the MSI PCI
> > capabilities registers, and so leaves these devices unusable for any
> > driver that attempts to use MSI.
> >
> > Setting that bit is not possible after the BIOS has locked down the
> > configuration registers, so we have to manually disable MSI for the
> > affected devices.
> >
> > This fixes the codec communication errors in the HDA driver when
> > accessing the HDMI audio device, and allows us to get rid of the
> > overcautious quirk in radeon_irq_kms.c.
> 
> Looks good.  This works properly on my rs780.
> 
> Tested-by: Alex Deucher <alexdeucher@gamil.com>

Great, applied to my for-linus branch.  I'll send it over to Linus this
week.

-- 
Jesse Barnes, Intel Open Source Technology Center
