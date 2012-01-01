Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2AAQhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 11:37:33 -0500
Received: from lo.gmane.org ([80.91.229.12]:53011 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab2AAQha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 11:37:30 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-15?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
Subject: microcode should perform update after suspend to disk
Date: Sun, 01 Jan 2012 17:37:13 +0100
Message-ID: <jdq23r$vni$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 31-18-52-176-dynip.superkabel.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111116 Thunderbird/8.0
X-Enigmail-Version: 1.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

at startup I load the microcode module and it correctly loads the
microcode from /lib/firmware/intel-ucode/. In dmesg, I can see that the
microcode has been updated from 0xc to 0xd.
After suspend to ram, dmesg shows new messages from the microcode
module, telling me that the microcode is still at revision 0xd. Hence,
no update is performed.
However, after suspend to disk, dmesg shows no new messages from the
microcode module. After rmmod microcode; modprobe microcode dmesg tells
me that the microcode had to be updated from 0xc to 0xd.

Somethings wrong here. My interpretation of the messages in dmesg is,
that microcode is trying to update the microcode after suspend to ram
but not after suspend to disk. It should try in both cases. Note that I
don't unload the microcode module.


Regards,
  Sven

