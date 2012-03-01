Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab2CAVEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:04:12 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:42187 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932534Ab2CAVEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:04:10 -0500
Date: Thu, 1 Mar 2012 13:04:08 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Warkentin <andreiw@vmware.com>,
        kgdb-bugreport@lists.sourceforge.net, Matt Mackall <mpm@selenic.com>,
        Andrei Warkentin <andrey.warkentin@gmail.com>
Message-ID: <1191723499.1820816.1330635848166.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1379096961.1660631.1330451032375.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Subject: Re: [PATCHv3 1/3] NETPOLL: Extend rx_hook support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Andrei Warkentin" <awarkentin@vmware.com>
> To: "Jason Wessel" <jason.wessel@windriver.com>
> Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Andrei Warkentin" <andreiw@vmware.com>,
> kgdb-bugreport@lists.sourceforge.net, "Matt Mackall" <mpm@selenic.com>, "Andrei Warkentin"
> <andrey.warkentin@gmail.com>
> Sent: Tuesday, February 28, 2012 12:43:52 PM
> Subject: Re: [PATCHv3 1/3] NETPOLL: Extend rx_hook support.
> 
> > 
> > All that netpoll_poll() did was to call netpoll_poll_dev().  I have
> > not yet looked at the differences between kgdboe and the netkdb
> > code
> > you proposed but I would have suspected it also falls victim to the
> > ethernet preemption problem which prevented kgdboe from ever being
> > considered for a mainline merge.  Certainly there are ways to fix
> > this
> > problem but most involved changes to scheduling, core net code, or
> > substantial driver specific changes.
> > 
> 
> I see, I read up on the issues w.r.t. preemption. Could this be
> worked
> around by modifiying affected drivers to bypass locking if they are
> used in KDB context? Make some accessor netdev-specific lock/unlocks
> that won't do anything if running in KDB context.
> 
>

By the way, is there a good way to repro the preemption case? Hopefully this doesn't
involve some crazy hardware...

A
