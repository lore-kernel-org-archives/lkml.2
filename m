Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0HBPfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:35:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:41466 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0HBPfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:35:17 -0400
Message-ID: <4C56E5C7.90206@suse.de>
Date: Mon, 02 Aug 2010 17:35:35 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de>
In-Reply-To: <4C56E42D.5010300@suse.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 05:28 PM, Tejun Heo wrote:
> The reason why poll_irq() looks complicated is because different types
> of timers on the same desc shares the timer.  The reason why it's
> shared this way instead of across different descs of the same type is
> to avoid locking overhead in maintaining the timer and linked lists of
> its targets.  By sharing the timer in the same desc, everything can be
> protected by desc->lock but if we use timers across different descs,
> we need another layer of locking.

Ooh, another reason is timer locality.  If timers are shared per desc,
they have much higher chance of being on the same processor.  Global
timers would be pretty bad in that respect.

-- 
tejun
