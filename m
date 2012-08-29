Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2H2SxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 14:53:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44187 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab2H2SxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 14:53:16 -0400
Date: Wed, 29 Aug 2012 20:53:29 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Amerigo Wang <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: "netpoll: re-enable irq in poll_napi()" breaks boot with netconsole
Message-ID: <20120829185329.GA2734@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Kernel 3.6-rc3 does not boot for me with netconsole enabled, while 3.6-rc2 did.
I bisected it to commit 6bdb7fe31046ac50b47e83c35cd6c6b6160a475d "netpoll:
re-enable irq in poll_napi()" and reverting it on top of current Linus' tree
restores proper behaviour (disabling netconsole does this too).
"Not booting" manifests as immediate hang after network card enabling.

Cheers,
Marcin
