Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2LPO2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 09:28:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2LPO2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 09:28:12 -0500
Date: Sun, 16 Dec 2012 14:28:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: tux2002@front.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] subsystem: pr??oc filesystem
Message-ID: <20121216142810.GB4939@ZenIV.linux.org.uk>
References: <20121213162207.GP4939@ZenIV.linux.org.uk>
 <5dca9c1a0bb851ebaa08ffb05941f90454ea3d6a@mail.qip.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dca9c1a0bb851ebaa08ffb05941f90454ea3d6a@mail.qip.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 04:02:03PM +0400, tux2002@front.ru wrote:
> Not, this permissions saved for all users for later, check please.

... and that's why it's bogus.  umask of whoever had done lookup for
/proc/<something> affects everybody else.  For as long as the thing stays
in dcache.  At which point it's up for grabs (in that sense) again.
Do (umask 777; ls -l /proc) with your kernel and watch the results.
Note that you don't need to be root to cause that - anyone can do it.

Realize that dentries and inodes in /proc/<pid>/* are created on demand
whenever somebody does a lookup.  So running ps(1) suddenly makes you
a creator of a bunch of those.  Unless somebody else had done ps(1) (or
ls -l /proc, or...) first.  Basing any security decisions on _that_ is
insane.
