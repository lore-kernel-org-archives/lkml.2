Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab0J0XaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:30:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38036 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab0J0XaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:30:15 -0400
Date: Thu, 28 Oct 2010 00:30:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: situation with signals
Message-ID: <20101027233012.GJ19804@ZenIV.linux.org.uk>
References: <20100923221141.GK19804@ZenIV.linux.org.uk>
 <9lYpY1#WLHA.1516@exchange1.tad.internal.tilera.com>
 <4CC89352.7020808@tilera.com>
 <20101027213745.GI19804@ZenIV.linux.org.uk>
 <4CC8ACE0.1040407@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC8ACE0.1040407@tilera.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 06:51:12PM -0400, Chris Metcalf wrote:

> > BTW, is everything in your pt_regs safe to modify?
> 
> What an interesting observation. :-)  In fact, it would be possible to
> overwrite the privilege level (the ex1 register) from within the signal
> handler and then return to run arbitrary code at kernel PL.  I'll fix it.

Then you need to be careful with that in your ptrace as well (POKEUSR and
SETREGS).
