Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0HRNEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:04:48 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34591 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627Ab0HRNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:04:46 -0400
X-Sasl-enc: 4on55+s0N70CFzw/41JzB4b/PacoHVw67VY8PBWp+QXt 1282136686
Message-ID: <4C6BDA7E.4080203@ladisch.de>
Date: Wed, 18 Aug 2010 15:05:02 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Peter Zijlstra <peterz@infradead.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>  <20100817143509.GC2838@zhy> <4C6AB76C.9060809@s5r6.in-berlin.de>  <4C6B8562.1070902@ladisch.de> <1282121942.1926.3552.camel@laptop> <4C6BA757.7050108@ladisch.de> <tkrat.2aa42a952e4df4b1@s5r6.in-berlin.de>
In-Reply-To: <tkrat.2aa42a952e4df4b1@s5r6.in-berlin.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Clemens Ladisch wrote:
> >  	spin_lock_irqsave(&card->lock, flags);
> >  	list_for_each_entry(t, &card->transaction_list, link) {
> >  		if (t == transaction) {
> > +			if (!del_timer(&t->split_timeout_timer))
> > +				goto timed_out;
> 
> +			if (!del_timer(&t->split_timeout_timer)) {
> +				spin_unlock_irqrestore(&card->lock, flags);
> +				goto timed_out;
> +			}

> Shall I commit with the added spin_unlocks?

I can obviously not be trusted to do this correctly; please go ahead.


Regards,
Clemens
