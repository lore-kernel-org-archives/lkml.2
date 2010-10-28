Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156Ab0J1SxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:53:17 -0400
Received: from www.tglx.de ([62.245.132.106]:48747 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400Ab0J1SxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:53:11 -0400
Date: Thu, 28 Oct 2010 20:52:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm-owner@vger.kernel.org
Subject: Re: [RFC IRQ] genirq: fix handle_nested_irq for lazy disable
In-Reply-To: <4CC9B167.8010401@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1010282050390.2692@localhost6.localdomain6>
References: <1288144209-28086-1-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1010270909590.3100@localhost6.localdomain6> <4CC9B167.8010401@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010, Abhijeet Dharmapurikar wrote:
> Thomas Gleixner wrote:
> > Aside of that this wont work for edge triggered interrupts, as you'd
> > loose the edge, so this needs more thought and a thorough look at the
> > users of handle_nested_irq().
> 
> I didn't understand this though. This patch will mask the interrupt in the
> controller even if it were edge. My interrupt controller latches
> edges and wants a mask (or an ack) to be executed to deactivate the line
> summary line. Do you mean that I should mark the interrupt IRQ_PENDING if it
> were an edge before masking it? If not, can you please explain.

See handle_edge_irq().

An edge is a one time event. Once you mask/ack it, it's gone. So now
when you unmask it won't reissue the interrupt on the hardware
level. Level interrupts do, as the mask does not affect that.

Thanks,

	tglx
