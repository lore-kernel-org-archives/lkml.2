Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab1JRKbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 06:31:47 -0400
Received: from server655-han.de-nserver.de ([85.158.177.45]:57756 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386Ab1JRKbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 06:31:46 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Oct 2011 06:31:45 EDT
Message-ID: <4E9D53FF.7090609@profihost.ag>
Date: Tue, 18 Oct 2011 12:25:03 +0200
From: Philipp Herz - Profihost AG <p.herz@profihost.ag>
Reply-To: p.herz@profihost.ag
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Vanilla-Kernel 3 - page allocation failure
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by p.herz@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After updating kernel (x86_64) to stable version 3 there are a few 
messages appearing in the kernel log such as

kworker/0:1: page allocation failure: order:1, mode:0x20
mysql: page allocation failure: order:1, mode:0x20
php5: page allocation failure: order:1, mode:0x20

Searching the net showed that these messages are known to occur since 2004.

Some people were able to get rid of them by setting 
/proc/sys/vm/min_free_kbytes to a high enough value. This does not help 
in our case.


Is there a kernel comand line argument to avoid these messages?

As of mm/page_alloc.c these messages are marked to be only warning 
messages and would not appear if 'gpf_mask' was set to __GFP_NOWARN in 
function warn_alloc_failed.

How does this mask get set? Is it set by the "external" process knocking 
at the memory manager?

What is the magic behind the 'order' and 'mode'?

I'm not a subscriber, so please CC me a copy of messages related to the 
subject. I'm not sure if I can help much by looking at the inside of the 
kernel, but I will try my best to answer any questions concerning this 
issue.

Best regards, Philipp
