Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2CJXPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 18:15:10 -0500
Received: from plane.gmane.org ([80.91.229.3]:33306 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab2CJXPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 18:15:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: finkler <finkler@officinamentis.org>
Subject: Questions about the console keyboard driver / translation tables
Date: Sun, 11 Mar 2012 00:14:11 +0100
Message-ID: <jjgn8b$evc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: wrzb-5f75be63.pool.mediaways.net
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I am trying to understand the logic of the Linux keyboard driver, I am 
not sure if this is the right place to ask, but I don't know where else 
I could.

Btw. I am talking about an unicode console here.

1.) The Linux kernel (currently) can take 256 translation tables 
(keymaps), I figured that if I have 8 Mod-Keys and I can press two at 
the same time, then this makes 256 possible modifications.
E.g. the value of my keycode of the button 'a' is 0x0b61 (small letter 
a) in table 0 and 0x0b41 (capital letter A) in table 1, so is it true 
that table 1 is for shift pressed keycodes?
If so, then why is shift (KG_SHIFT in linux/keyboard.h [1]) set to 0, 
and how do I compute the modifications, meaning how do I know what e.g. 
index 231 represents?

2.) As seen above, the value for 'a' is actually 0x0b61 instead of 
0x0061, if b indicates a type (here KT_LOCK) why isn't it 0xfb61, 
because I thought that only values above 0xf000 represent typed values, 
and the values below are simply unicode values.
The values above are read via the KDGKBENT ioctl [2], are these values 
read differently then written?
E.g. would I only type 0xfb61 when using the KDSKBENT ioctl?

3.) If I wanted to assign "Return" to a keycode, what is the difference 
between using a simple 0x000d (13) and the KT_SPEC type with the 
function fn_enter (which is supposedly 0xf201)?

I hope anyone can help me out a little,
thank you very much in advance,
regards,
Finkler

1: http://tomoyo.sourceforge.jp/cgi-bin...nux/keyboard.h
2: http://www.kernel.org/doc/man-pages/...e_ioctl.4.html

