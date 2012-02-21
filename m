Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2BUNqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:46:01 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:40820 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab2BUNqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:46:00 -0500
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Feb 2012 08:46:00 EST
Message-ID: <4F439E17.8090507@parrot.com>
Date: Tue, 21 Feb 2012 14:37:27 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Egmont Koblinger <egmont@gmail.com>, Alan Cox <alan@redhat.com>
Subject: re : PROBLEM: Data corruption when pasting large data to terminal
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> - I couldn't reproduce with cat-like applications, I have a feeling
> perhaps the bug only occurs in raw terminal mode, but I'm really not
> sure about this.

We saw in our case a possible data corruption in the tty layer :
in n_tty the n_tty_receive_buf can drop characters if it can't copy all of them
in the tty circular buffer.

A fix should be to remove tty->receive_room and make n_tty_receive_buf  return
the number of bytes copied.

A patch to correct this was done in b1c43f82c5aa265442f82dba31ce985ebb7aa71c,
but it was reverted because it was buggy.

May be you should check that this is not your problem.


Matthieu
