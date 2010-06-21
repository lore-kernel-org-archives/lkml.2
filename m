Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab0FUNwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:52:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:57383 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab0FUNww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:52:52 -0400
Message-ID: <4C1F6E8E.6050301@kernel.org>
Date: Mon, 21 Jun 2010 15:52:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: jeff@garzik.org
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org>
In-Reply-To: <1276443098-20653-12-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 21 Jun 2010 13:52:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 05:31 PM, Tejun Heo wrote:
> Thanks to its age, ATA is very susceptible to IRQ delivery problems in
> both directions - lost and spurious interrupts.  In traditional PATA,
> the IRQ line is ultimately out of the controller and driver's control.
> Even relatively new SATA isn't free from these issues.  Many
> controllers still emulate the traditional IDE interface which doesn't
> have reliable way to indicate interrupt pending state and there also
> is an issue regarding the interpretation of nIEN on both sides of the
> cable.
> 
> Most of these problems can be worked around by using the new IRQ
> expecting mechanism without adding noticeable overhead.  In ATA,
> almost all operations are initiated by the host and the controller
> signals progress or completion using IRQ.  IRQ expecting can easily be
> added in libata core and applied to all libata drivers.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Jeff, can you please ack this change if this looks okay to you?  Also,
would it okay to route this through irq tree?

Thanks.

-- 
tejun
