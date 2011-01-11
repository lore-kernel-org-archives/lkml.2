Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1AKFV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:21:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:55971 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1AKFVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:21:52 -0500
Subject: Re: [PATCH -v3 1/4] pci, usb:  Make usb handoff func all take base
 remapping
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <greg@kroah.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D2BB048.2050509@kernel.org>
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org>
	 <4D2BA8FE.9090204@kernel.org> <4D2BAA75.60001@kernel.org>
	 <20110111010714.GB32585@kroah.com>  <4D2BB048.2050509@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 16:21:30 +1100
Message-ID: <1294723290.17779.349.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 17:20 -0800, Yinghai Lu wrote:
> 
> for early access, can not use udelay yet, it will take some one.
> Also msleep will cause crash, because it needs scheduler there.

Right, and that's for such special cases (hopefully rare) that we have
system_state... Much better than your function pointers I reckon.

We could even wrap it into a safe_delay() function or whatever (in fact
why not make msleep() itself safe ? It's not like it was timing critical
code :-)

Cheers,
Ben.


