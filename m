Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2GISpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:45:53 -0400
Received: from edge.cmeerw.net ([84.200.12.152]:57075 "EHLO edge.cmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab2GISpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:45:51 -0400
Date: Mon, 9 Jul 2012 20:45:39 +0200
From: Christof Meerwald <cmeerw@cmeerw.org>
To: "Paton J. Lewis" <palewis@adobe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH] epoll: Improved support for multi-threaded clients
Message-ID: <20120709184539.GI7275@edge.cmeerw.net>
References: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
 <20120616184707.GA22656@edge.cmeerw.net>
 <6.2.5.6.2.20120618161807.031eb6c8@adobe.com>
 <20120619181711.GE1281@edge.cmeerw.net>
 <6.2.5.6.2.20120629140909.04bb0a40@adobe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.2.5.6.2.20120629140909.04bb0a40@adobe.com>
X-PGP-Key: 1024D/2B10BE68, 1998-06-29
X-PGP-Fingerprint: 0289 5466 C1F5 B03C DBA7  6304 8CAF 9782 2B10 BE68
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 02:43:06PM -0700, Paton J. Lewis wrote:
> At 6/19/2012 11:17 AM, Christof Meerwald wrote:
> >But, taking one step back - wouldn't an alternative approach be to add
> >some mechanism to allow a thread to post a user-event for an fd? So in
> >delete_epoll_item you would post a user event (e.g. EPOLLUSER) for the
> >fd which you can then handle in your epoll_wait processing thread -
> >with no additional synchronisation necessary.
> I think this is an excellent suggestion, and in fact your proposal
> is more similar to what Windows provides when solving this problem.
> I'll test this idea out with our code and get back to you. Is there
> an existing kernel technique that you would recommend for posting a
> user event for an fd, or should I explore using epoll_ctl with
> EPOLL_CTL_MOD?

I don't know about any existing kernel technique for this, but my gut
feeling would be a new op value for epoll_ctl, maybe something like
EPOLL_CTL_TRIGGER.


Christof

-- 

http://cmeerw.org                              sip:cmeerw at cmeerw.org
mailto:cmeerw at cmeerw.org                   xmpp:cmeerw at cmeerw.org
