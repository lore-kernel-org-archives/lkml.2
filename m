Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab1IGRvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:51:23 -0400
Received: from corega.com.ru ([195.178.208.66]:33487 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751223Ab1IGRvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:51:22 -0400
Date: Wed, 7 Sep 2011 21:50:59 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jan Weitzel <j.weitzel@phytec.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] w1: Disable irqs in critical section
Message-ID: <20110907175059.GA12074@ioremap.net>
References: <1315385312-1176-1-git-send-email-j.weitzel@phytec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315385312-1176-1-git-send-email-j.weitzel@phytec.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 10:48:32AM +0200, Jan Weitzel (j.weitzel@phytec.de) wrote:
> Interrupting w1_delay in w1_read_bit results in missing the low level
> on the w1 line and receiving "1" instead of "0".
> Adding local_irq_save / local_irq_restore around the critical section

This means that CPU will be essentially stuck for 15 useconds for every
bit transferred, doesn't really look like a good idea.

Are you absolutely sure that missing bit is because of timings and not
some other bug?

-- 
	Evgeniy Polyakov
