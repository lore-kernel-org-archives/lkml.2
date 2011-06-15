Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1FOJ2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:28:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:33137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab1FOJ2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:28:49 -0400
Subject: Re: [PATCH 5/7] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <4DF805F3.4030603@redhat.com>
References: <1308007897-17013-1-git-send-email-glommer@redhat.com>
	 <1308007897-17013-6-git-send-email-glommer@redhat.com>
	 <1308046203.19856.9.camel@twins>  <4DF805F3.4030603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Jun 2011 11:28:22 +0200
Message-ID: <1308130102.15315.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 22:08 -0300, Glauber Costa wrote:
> >> +               while (steal>  TICK_NSEC) {
> >
> >                       /* really, if we wanted a division we'd have
> written one */
> >                       asm("" : "+rm" (steal));
> 
> Out of curiosity, have we seen any compiler de-optimize it to a 
> division, or are you just being careful ?
> 
> >> +                       steal -= TICK_NSEC;
> >> +                       st++;
> >> +               } 

No that really happened a number of times, there's one in
sched_avg_period() that actually triggered and __iter_div_u64_rem() that
started it all iirc.
