Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2AYVip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:38:45 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48343 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2AYVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:38:44 -0500
Message-ID: <4F207660.500@suse.cz>
Date: Wed, 25 Jan 2012 22:38:40 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120118 Thunderbird/10.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Why are not processes HUPped when they open /dev/console?
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

don't you remember by a chance the reason for this test in __tty_hangup:
  if (filp->f_op->write != tty_write)

The logic there is not to HUP processes that have this tty open via
/dev/console.

It is there like forever. But now, due to that, processes that do
vhangup of /dev/ttyXYZ wait infinitely if there is some other process
that has the ttyXYZ open through /dev/console. (Due to infinite wait in
tty_ldisc_hangup.)

This happens on some distros on shutdown path because they do vhangup on
all tty[0-8] ttyS[01] and similar.

thanks,
-- 
js
suse labs
