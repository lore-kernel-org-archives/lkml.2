Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1AJS2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:28:07 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:34550 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753964Ab1AJS2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:28:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DX41Og1MFTImlesWVEFEeSErCNAinixqF2WXMbNGIZJOgtxkA/788hNO8jZCeluQRfVgKPu4esKsLrx+M9JERWPavIsj5oAEomb/f4vl91hgq3kWd7+Kf5vYu63o4YyJ;
Date: Mon, 10 Jan 2011 10:27:59 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 0/3] x86, usb, pci: Disable usb legacy support early
Message-ID: <20110110102759.3780cfe6@jbarnes-desktop>
In-Reply-To: <20110110155724.GA5275@kroah.com>
References: <4D2A1382.7010407@kernel.org>
	<20110110155724.GA5275@kroah.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 07:57:24 -0800
Greg KH <greg@kroah.com> wrote:

> On Sun, Jan 09, 2011 at 11:58:58AM -0800, Yinghai Lu wrote:
> > move quirks for usb handoff early for x86.
> > 
> > So we can get stable result when trying to calibrate apic timer with pm-timer.
> 
> Is this a real problem today?  What is the symptom of the issue?  Where
> was it reported as a problem?

Yes, please give us a rationale for all this mess.  I really don't like
the sleep wrappers or the "early" PCI device; would it be easier to
extract some of the core disabling MMIO from the quirks and re-use it
for a totally separate set of early quirk functions?  Like Ben
suggested, making it totally arch specific would be a good option,
though presumably most arches don't need this (again if you explained
why/when this was needed maybe we could come up with a better
solution, or just ignore the problem if you're trying to fix a
pre-production board again with all sorts of broken stuff).

-- 
Jesse Barnes, Intel Open Source Technology Center
