Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1HRRuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:50:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab1HRRuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:50:54 -0400
Date: Thu, 18 Aug 2011 19:47:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 18/41] OpenRISC: Don't reimplement force_sigsegv()
Message-ID: <20110818174753.GC6910@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-19-git-send-email-matt@console-pimps.org> <20110816164928.GA29190@redhat.com> <1313523202.3436.180.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313523202.3436.180.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Matt Fleming wrote:
>
> On Tue, 2011-08-16 at 18:49 +0200, Oleg Nesterov wrote:
> >
> > And since force_sigsegv() drops
> > the lock after setting SIG_DFL we can "race" with the sub-thread anyway.
>
> I did notice that race in force_sigsegv() too, is it a real problem?

Oh, I don't really know. I mean, I do not know if this really needs
the fix.

OK, suppose that another thread does signal(SIGSEGV, SIG_IGN) in
between. This probably means it asks for the problems anyway. and
we can pretend this was done before this SIGSEGV was dequeued.

If it does signal(SIGSEGV, my_handler), then most probably
force_sigsegv() will be called again soon, after dequeueing SIGSEGV.

Oleg.

