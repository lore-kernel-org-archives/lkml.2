Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0JGVm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:42:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61387 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab0JGVmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:42:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="56993445"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Mike Frysinger <vapier@gentoo.org>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
In-Reply-To: <20101007223819.46246716@lxorguk.ukuu.org.uk>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
	 <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
	 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
	 <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
	 <20101007223819.46246716@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 14:41:58 -0700
Message-ID: <1286487718.23836.94.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 22:38 +0100, Alan Cox wrote:
> > Your making too many assumptions .. You might be able to modify the
> > kernel, and not the userspace. So you couldn't tweak the device
> > creation .. It's much easier in the server world ..
> 
> Spare me the embedded is different lecture. It's not. In fact it's
> usually easier because the environment you are testing is usually
> standalone, doesn't cause a million dollar an hour downtime if you get it
> wrong and was designed for debug/test so actually has a jtag port.

fair enough, it's hard for both of us.

> If you can modify the file system you can make /dev/ttyS0 the major/minor
> of the jtag port.
> 
> If you can load anything in front of the userspace you can rename the
> device/move it
> 
> So I find your example case fictional. In fact the only time I can see
> you having a box so tightly locked up you can only tweak the kernel is
> jailbreaking it, in which case you are such a fringe usage case and
> technically competent that you can just do custom patches as you'll be
> doing anyway for other bits.

There's lots of other situations that can come up. You can't in anyway
say that there is some certain set of situations where you'll always
have X, Y, and Z.. There have been enough strange situations that I
don't think it's right for you or me to assume we just know what they
all are.

> > > We've said no over a period of about ten years to a lot of attempts to
> > > just borrow the ttyS0 range. If we'd said yes it would have been a
> > > complete mess by now.
> > > 
> > > So the answer is no.
> > 
> > Nothing can be unilateral, there's always room for exceptions. You
> > should say something more like "it's possible, but unlikely".
> 
> This argument gets regurgitated every so often and nobody has yet
> provided a plausable reason to make a nasty mess.

There's plenty of nasty messes in the kernel, "they" must have had some
justification ..

> Either way I would suggest the path forward is
> 
> - Look at the blackfin jtag using tty_port alone and see if it looks
>   cleaner

Yeah ..

> - Fix the bugs noted

Check,

> - Submit a driver that uses the existing allocated jtag major/minor only

The driver does this already. It uses ttyJ* by default, and ttyS is an
option ..

> and then have a debate about ttyS0 hackery separately.

Fine with me..

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

