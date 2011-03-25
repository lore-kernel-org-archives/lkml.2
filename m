Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1CYSSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:18:05 -0400
Received: from ns2.coplanar.net ([199.27.182.4]:36033 "EHLO titan.coplanar.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752343Ab1CYSSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:18:04 -0400
X-Greylist: delayed 2165 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Mar 2011 14:18:04 EDT
Message-ID: <4D8CD3D4.90900@coplanar.net>
Date: Fri, 25 Mar 2011 13:41:40 -0400
From: Jeremy Jackson <jerj@coplanar.net>
Organization: Coplanar Networks
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: signal to PID 1 from serial console like KeyboardRequest or CAD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (titan.coplanar.net [199.27.182.2]); Fri, 25 Mar 2011 13:41:57 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sent to linux-console with no reply for over a week...

I ran into a problem recently on a Linux server with a remote serial 
console.  /sbin/init (actually Upstart) was in a state where nothing 
(useful) was running.  I had to power cycle the machine to get back to 
the boot prompt.  This has the side-effect of triggering raid rebuilds.

It would be nice to have what Ctrl-Alt-Del does at the VGA console with 
PS/2 or USB keyboard. This sends a SIGINT to PID 1, and most distros 
have this set to do "shutdown -r now" which attempts a clean reboot.

Once upon a time there was KeyboardRequest, which would send a SIGWINCH 
to PID 1 (when pressing Alt-UP_arrow?).  I don't see any sign of this 
feature in Linux 2.6.32 though.

Looking at the Sysrq handlers in the kernel I don't see any keystrokes 
that send SIGINT to PID 1 either.

So, I'm wondering if it makes sense to add a Sysrq key to send a signal 
to PID1 ?

-- 
Coplanar Networks
http://www.coplanar.net
(519)489-4903
