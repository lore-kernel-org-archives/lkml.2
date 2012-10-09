Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab2JIQID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:08:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49168 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2JIQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:08:00 -0400
Date: Tue, 9 Oct 2012 17:06:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonathan Austin <jonathan.austin@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 4/9] ARM: export default read_current_timer
Message-ID: <20121009160647.GG4625@n2100.arm.linux.org.uk>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de> <1349796183-30648-5-git-send-email-arnd@arndb.de> <50744586.6010806@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50744586.6010806@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:40:54PM +0100, Jonathan Austin wrote:
> Hi Arnd,
> 
> On 09/10/12 16:22, Arnd Bergmann wrote:
> > diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
> > index 9d0a300..0dc5385 100644
> > --- a/arch/arm/lib/delay.c
> > +++ b/arch/arm/lib/delay.c
> > @@ -45,6 +45,7 @@ int read_current_timer(unsigned long *timer_val)
> >  	*timer_val = delay_timer->read_current_timer();
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL_GPL(read_current_timer);
> 
> 
> Perhaps this fits better in armksyms.c? That way it lives with
> arm_delay_ops and friends.

It's always much better to put things next to where they're defined
rather than spreading them around.

armksyms.c is a reminant of the 1.x days of doing things... but still
remains to allow what are mostly assembly symbols to be exported.
