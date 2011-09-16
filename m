Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab1IPKTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 06:19:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48108 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1IPKTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 06:19:05 -0400
Date: Fri, 16 Sep 2011 11:19:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com, raven@themaw.net
Subject: Re: [PATCH] Force same size of struct autofs_v5_packet on x86 and
 x86_64
Message-ID: <20110916101903.GI2203@ZenIV.linux.org.uk>
References: <1316167604.6545.84.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316167604.6545.84.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 12:06:38PM +0200, Thomas Meyer wrote:
> autofs_v5_packet is 300 bytes on x86 and 304 bytes on x86_64.
> This difference is wrong and leads to a hang in systemd when running
> a x86 userspace on an x86_64 kernel.

NAK.

You are talking about the userland ABI.  With existing users.  Changing
it might help systemd (what the hell is it doing with autofs, anyway?),
but breaking existing binaries (you know, ones that *do* have some business
dealing with autofs) is not acceptable.
