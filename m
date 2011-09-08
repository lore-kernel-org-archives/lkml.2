Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab1IHFqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 01:46:24 -0400
Received: from mail.x-arc.de ([217.6.246.34]:44618 "EHLO root.phytec.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898Ab1IHFqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 01:46:23 -0400
Subject: Re: [RFC] w1: Disable irqs in critical section
From: Jan Weitzel <J.Weitzel@phytec.de>
Reply-To: J.Weitzel@phytec.de
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110907175059.GA12074@ioremap.net>
References: <1315385312-1176-1-git-send-email-j.weitzel@phytec.de>
	 <20110907175059.GA12074@ioremap.net>
Organization: PHYTEC Messtechnik GmbH
Date: Thu, 08 Sep 2011 07:46:21 +0200
Message-ID: <1315460781.4396.10.camel@lws-weitzel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-MIMETrack: Itemize by SMTP Server on Idefix/Phytec(Release 8.5.2FP2|March 22, 2011) at
 08.09.2011 07:46:22,
	Serialize by Router on Idefix/Phytec(Release 8.5.2FP2|March 22, 2011) at
 08.09.2011 07:46:22,
	Serialize complete at 08.09.2011 07:46:22
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 07.09.2011, 21:50 +0400 schrieb Evgeniy Polyakov:
> On Wed, Sep 07, 2011 at 10:48:32AM +0200, Jan Weitzel (j.weitzel@phytec.de) wrote:
> > Interrupting w1_delay in w1_read_bit results in missing the low level
> > on the w1 line and receiving "1" instead of "0".
> > Adding local_irq_save / local_irq_restore around the critical section
> 
> This means that CPU will be essentially stuck for 15 useconds for every
> bit transferred, doesn't really look like a good idea.
> 
> Are you absolutely sure that missing bit is because of timings and not
> some other bug?
> 

I trigger a gpio line after the samplepoint. I case of a wrong bit the
sample is taken after the "0 gap". The cycle time (samplt to sample)is
increased form about 80µs to 95µs. 
I did the measurement with the w1-gpio driver on a OMAP4 board.

Jan


