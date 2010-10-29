Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab0J2Rig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:38:36 -0400
Received: from mxout3.netvision.net.il ([194.90.6.2]:64691 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0J2Rie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:38:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <4CCB06FE.8050705@billauer.co.il>
Date: Fri, 29 Oct 2010 19:40:14 +0200
From: Eli Billauer <eli@billauer.co.il>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
To: linux-kernel@vger.kernel.org
Subject: pty.c: tty_lock() and tty_unlock() in reverse order?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


After having some problems with a simple open of /dev/tty taking 30 
seconds or so (more precisely, a complete freeze of login console and 
very slow ssh), I looked a bit into the kernel code.


My very recently downloaded kernel.org 2.6.36's pty.c goes as below. 
What bothers me is that tty_unlock() is called first, and tty_lock() 
just before exiting. Shouldn't it be the other way around?


static void pty_close(struct tty_struct *tty, struct file *filp)
{


    [snipped some code here, no games with locks]

        tty_*un*lock();
        tty_vhangup(tty->link);
        tty_lock();
    }
}


    Eli

-- 
Web: http://www.billauer.co.il

