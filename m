Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1H0AAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 20:00:52 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:59971 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1H0AAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 20:00:51 -0400
Date: Fri, 26 Aug 2011 20:00:40 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/4] x86: base support for the TS-5500 platform
Message-ID: <20110826200040.2025eb0b@v0nbox>
In-Reply-To: <4E55836D.8030209@zytor.com>
References: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314217407-31249-2-git-send-email-vivien.didelot@savoirfairelinux.com>
	<4E55670F.90102@zytor.com>
	<20110824180837.6841f3d8@v0nbox>
	<4E5576CF.2050905@zytor.com>
	<20110824183814.64abc94c@v0nbox>
	<4E55836D.8030209@zytor.com>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 16:04:13 -0700,
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/24/2011 03:38 PM, Vivien Didelot wrote:
> > 
> > I agree with you. The platform does not provide many identification
> > points. We have specific hardware such as the CPU, Ethernet, Cardbus
> > and USB controllers; there is no DMI available; no PCI bridge
> > subvendor info, only the BIOS provides a 16-bit identification
> > call... We discussed that point in
> > https://lkml.org/lkml/2011/5/4/437 without success.
> > 
> > What would be the proper way in your opinion?
> > 
> > Vivien.
> 
> First of all, given that these clowns seem to be selling a product
> specifically targeting Linux support, they really need to be given a
> clue transfusion.  It is *NOT* acceptable to not provide DMI, and
> *NOT* acceptable not to set the subvendor information.
> 
> We should arguably push for them to fix that in their BIOSes, but that
> is as usual too little, too late.
> 
> Probably the best option we have is to look for some kind of magic
> string in their BIOS -- i.e. the classic way to detect things before
> DMI existed.
> 
> If not, you're going to have an explicit switch on the kernel command
> line, but that is an absolute last resort.
> 
> 	-hpa

Hi,

The initialization function is now reading the BIOS to find this magic
string, thanks for the tip. I've sent the updated version. The
corresponding thread is here: https://lkml.org/lkml/2011/8/26/425.

Regards,
Vivien.
