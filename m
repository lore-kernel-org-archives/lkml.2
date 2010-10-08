Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab0JHRpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:45:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35978
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759182Ab0JHRpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:45:36 -0400
Date: Fri, 08 Oct 2010 10:45:57 -0700 (PDT)
Message-Id: <20101008.104557.59696706.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: dilinger@queued.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2 v2] of: move phandle/ihandle into types.h and
 export to userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101008173650.GH3863@angua.secretlab.ca>
References: <20101008171210.GE3863@angua.secretlab.ca>
	<20101008.101759.193728130.davem@davemloft.net>
	<20101008173650.GH3863@angua.secretlab.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 8 Oct 2010 11:36:50 -0600

> Weird.  Yeah, no other platforms expect to get a phandle type
> definition from the kernel headers.  The only thing driving this
> conversation is from arch/sparc/include/asm/Kbuild:
> 
> header-y += openprom.h

It was probably at one point for the sake of asm/openpromio.h but
that header has no dependencies on openprom.h

The only hit I can find in google code search, for non-kernel code, is
the SILO bootloader.

But that tree includes it's own copy of include/asm/openprom.h so
the actual kernel copy isn't even used.

I'd say we can stop exporting that header and also therefore not
worry about making phandle_t visible to userspace.


