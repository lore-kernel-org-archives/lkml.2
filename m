Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab1INTp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:45:57 -0400
Received: from intermatrixgroup.ru ([195.178.208.66]:56764 "EHLO
	tservice.net.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757424Ab1INTp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:45:56 -0400
Date: Wed, 14 Sep 2011 23:45:49 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jan Weitzel <J.Weitzel@phytec.de>
Cc: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] w1: Disable irqs in critical section
Message-ID: <20110914194549.GA20300@ioremap.net>
References: <1315385312-1176-1-git-send-email-j.weitzel@phytec.de>
 <20110907175059.GA12074@ioremap.net>
 <1315460781.4396.10.camel@lws-weitzel>
 <20110913154142.f14b2c4c.akpm@google.com>
 <1316003005.4369.10.camel@lws-weitzel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1316003005.4369.10.camel@lws-weitzel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 02:23:25PM +0200, Jan Weitzel (J.Weitzel@phytec.de) wrote:
> > Finally, can we fine-tune the interrupt-disabled section a bit?  For
> > example, can the local_irq_disable() be moved to after the
> > write_bit(..., 0)?
> > 
> The falling edge from 1 to 0 starts timing for the slave. After the 6µs
> the slave should drive the line low (In case the information bit is
> "0"). So there is no additional edge on the line. If there is an
> interrupt and the low pulse from master is longer, slave did't see it.
> Master need to generate the 1 -> 0 transition and measure after 15µs
> 
> I tested it anyhow. Behaviour is slightly better than without disabling
> interrupts. Only disabling it for 15µs fix the problem. 

Sad story, but if it is the only solution, then we should go with it.

Andrew, please push this patch upstream.

Thank you Jan.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
