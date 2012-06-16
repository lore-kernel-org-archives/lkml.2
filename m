Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2FPSwz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 14:52:55 -0400
Received: from edge.cmeerw.net ([84.200.12.152]:45798 "EHLO edge.cmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab2FPSwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 14:52:54 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jun 2012 14:52:54 EDT
Date: Sat, 16 Jun 2012 20:47:07 +0200
From: Christof Meerwald <cmeerw@cmeerw.org>
To: Paton Lewis <palewis@adobe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [PATCH] epoll: Improved support for multi-threaded clients
Message-ID: <20120616184707.GA22656@edge.cmeerw.net>
References: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
X-PGP-Key: 1024D/2B10BE68, 1998-06-29
X-PGP-Fingerprint: 0289 5466 C1F5 B03C DBA7  6304 8CAF 9782 2B10 BE68
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012 15:34:49 -0700, Paton Lewis wrote:
> This patch introduces the new epoll_ctl command EPOLL_CTL_DISABLE, which
> disables the associated epoll item and returns -EBUSY if the epoll item is not
> currently in the epoll ready queue. This allows multiple threads to use a
> mutex to determine when it is safe to delete an epoll item and its associated
> resources. This allows epoll items to be deleted and closed efficiently and
> without error.

Do you assume that EPOLLONESHOT is being used for this to work or
would you expect your patch to also address the case where
EPOLLONESHOT is not used?


Christof

-- 

http://cmeerw.org                              sip:cmeerw at cmeerw.org
mailto:cmeerw at cmeerw.org                   xmpp:cmeerw at cmeerw.org
