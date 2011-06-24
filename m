Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab1FXJrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 05:47:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:55661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1FXJrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 05:47:13 -0400
Subject: Re: [PATCH 3/3] events: Ensure that timers are updated without
 requiring read() call
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: mingo@elte.hu, borislav.petkov@amd.com, bblum@andrew.cmu.edu,
        linux-kernel@vger.kernel.org, mhack@us.ibm.com, eranian@google.com
In-Reply-To: <1308908656.27849.21.camel@twins>
References: <1308861279-15216-1-git-send-email-emunson@mgebm.net>
	 <1308861279-15216-3-git-send-email-emunson@mgebm.net>
	 <1308908656.27849.21.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Jun 2011 11:46:21 +0200
Message-ID: <1308908781.27849.23.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 11:44 +0200, Peter Zijlstra wrote:
> > +     calc_timer_values(event,
> > +                             &event->total_time_enabled,
> > +                             &event->total_time_running);
> 
> I'm not sure writing those from NMI context is a sane thing to do, best
> is to compute the values into a local variable and use that variable
> below. 

To clarify, on 32bit architectures the NMI might come in the middle of
writing the two words of one of those, writing them again from the NMI
handler will result in overlapping writes, which might lead to some
weird end-results.

