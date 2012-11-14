Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423086Ab2KNQmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:42:47 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:46079 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422685Ab2KNQmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:42:45 -0500
Date: Wed, 14 Nov 2012 08:42:44 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, George Zhang <georgezhang@vmware.com>
Message-ID: <1636188668.22560872.1352911364387.JavaMail.root@vmware.com>
In-Reply-To: <50A01FB1.1080502@gmail.com>
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.160.14]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - GC23 (Mac)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

Thanks for taking a look.

> So all the documentation I see in the VMCI Socket Programming Guide
> is about userspace programming, and the documentation in af_vsock.c
> is all around implementation considerations.

Agreed, we're sorely lacking in proper documentation for the internal
protocol.  We're in the process of writing such a specification and
will post it to LKML next week at the latest.

> example, whats the deal with REQUEST/REQUEST2? it appears like
> something to deal with legacy code, but I'd really like to have it
> documented somewhere instead of trying to figure how everything

Correct, we have a legacy protocol and a v2, the latter now being
the default.  This particular packet is sent by the client when
initiating a STREAM connection.  The sequence is REQUEST(2)->
NEGOTIATE(2)->OFFER->ACCEPT.  It will be properly documented in
the specification we post next week.

Thanks!
- Andy
