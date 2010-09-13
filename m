Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab0IMHyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:54:04 -0400
Received: from mail.lncsa.com ([213.215.28.11]:60283 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751434Ab0IMHyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:54:02 -0400
Date: Mon, 13 Sep 2010 09:52:37 +0200
From: Louis-David Mitterrand <vindex+lists-linux-kernel@apartia.org>
To: linux-kernel@vger.kernel.org
Subject: Re: ksoftirqd/n permanently eating 60% of a CPU
Message-ID: <20100913075237.GA18081@apartia.fr>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20100912154138.GA23554@apartia.fr>
 <20100912185715.GA8775@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912185715.GA8775@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 08:57:15PM +0200, Andreas Mohr wrote:
> > Examining /proc/interrupts shows that "Local timer interrupts" are
> > mainly firing.
> 
> > Strangely enough, the interrupt storm starts only 5 minutes or so after
> > bootup.
> 
> And have you tried running powertop or manually (perhaps via
> sophisticated shell script) keeping a watch on
> /proc/timer[list|stats]?

Hi,

powertop seems to give a strong hint:

	54.5% (250.2)   [kernel core] dsp_cmx_send (dsp_cmx_send)
	25.8% (118.6)   usbhid-ups
	5.8% ( 26.7)   [ahci] <interrupt>
	2.6% ( 12.0)   [kernel core] usb_hcd_poll_rh_status (rh_timer_func)

Apparently dsp_cmx_send is in the mISDN stack which, in my kernel, is
compiled statically. This happens regardless of the box having isdn
hardware.
