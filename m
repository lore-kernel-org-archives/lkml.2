Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1HAMH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:07:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:46721 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1HAMHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:07:53 -0400
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20110801112102.GQ2209@sun>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
	 <20110731110641.GG2209@sun>
	 <CAC9WiBgg+To8ggUvTqxOCy2hgb=XQCRH6D_0HFy4sEEoF8R0rw@mail.gmail.com>
	 <20110731153225.GJ2209@sun> <1312196702.2617.445.camel@laptop>
	 <20110801112102.GQ2209@sun>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 14:12:34 +0200
Message-ID: <1312200754.2617.454.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 15:21 +0400, Cyrill Gorcunov wrote:
> >       mutex_lock(&swhash->hlist_mutex);
> > -     if (swhash->hlist_refcount > 0) {
> > +     if (swhash->hlist_refcount > 0 && !swhash->swevent_hlist) {
> 
> Should not there be rcu_dereference(swhash->swevent_hlist)? 

swhash->hlist_mutex is the modifier lock for that rcu use and should
thus serialize things sufficiently.

