Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2FRX0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 19:26:22 -0400
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:35238 "EHLO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2FRX0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:26:19 -0400
Message-ID: <6.2.5.6.2.20120618161807.031eb6c8@adobe.com>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Mon, 18 Jun 2012 16:24:35 -0700
To: Christof Meerwald <cmeerw@cmeerw.org>
From: "Paton J. Lewis" <palewis@adobe.com>
Subject: Re: [PATCH] epoll: Improved support for multi-threaded clients
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <20120616184707.GA22656@edge.cmeerw.net>
References: <F044A95E1307394EBA6055B1B7144CD2010CFB1B748F@NAMBX02.corp.adobe.com>
 <20120616184707.GA22656@edge.cmeerw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christof,

We believe that EPOLLONESHOT is required in order to make any 
sensible use of calling epoll_wait on a single epoll set concurrently 
in multiple threads. So in that sense the new functionality is really 
only useful for coordinating resource deletion between threads when 
using EPOLLONESHOT. However, when EPOLLONESHOT is not used, 
EPOLL_CTL_DISABLE still disables the item, and can be used solely for 
that purpose if the caller intends to re-enable the item via 
EPOLL_CTL_MOD and doesn't wish to incur the additional overhead 
associated with deleting and re-adding an item.

Thank you,
Pat

At 6/16/2012 11:47 AM, Christof Meerwald wrote:
>On Mon, 11 Jun 2012 15:34:49 -0700, Paton Lewis wrote:
> > This patch introduces the new epoll_ctl command EPOLL_CTL_DISABLE, which
> > disables the associated epoll item and returns -EBUSY if the 
> epoll item is not
> > currently in the epoll ready queue. This allows multiple threads to use a
> > mutex to determine when it is safe to delete an epoll item and 
> its associated
> > resources. This allows epoll items to be deleted and closed efficiently and
> > without error.
>
>Do you assume that EPOLLONESHOT is being used for this to work or
>would you expect your patch to also address the case where
>EPOLLONESHOT is not used?
>
>
>Christof
>
>--
>
>http://cmeerw.org                             sip:cmeerw at cmeerw.org
>mailto:cmeerw at cmeerw.org                   xmpp:cmeerw at cmeerw.org

