Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0LQNzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:55:00 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:56102 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272Ab0LQNy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:54:59 -0500
Date: Fri, 17 Dec 2010 14:51:17 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Duncan Sands <duncan.sands@free.fr>,
        linux-kernel@vger.kernel.org
Subject: Re: speedtch: don't abuse struct delayed_work
Message-ID: <20101217145117.75a28ae0@absol.kitzblitz>
In-Reply-To: <1292172499-21633-1-git-send-email-tj@kernel.org>
References: <20101216213005.GA5781@kroah.com> <1292172499-21633-6-git-send-email-tj@kernel.org> <1292172499-21633-1-git-send-email-tj@kernel.org>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Dec 12, 2010 at 05:48:18PM +0100, Tejun Heo wrote:
>> speedtch directly uses the internal timer and work members of a struct
>> delayed_work.  Use a separate work item and timer instead.

>> This is part of a series to remove flush_scheduled_work() usage to
>> prepare for deprecation of flush_scheduled_work().  Patches in this
>> series are self contained and mostly straight-forward

I tested this patch with 2.6.37-rc6. Not sure whether 
I'm doing something wrong, but I failed to start the
PPP daemon with my speedtouch usb:

Dec 17 14:17:24 absol pppd[4853]: Plugin pppoatm.so loaded.
Dec 17 14:17:24 absol pppd[4853]: PPPoATM plugin_init
Dec 17 14:17:24 absol pppd[4853]: PPPoATM setdevname_pppoatm - SUCCESS:8.48
Dec 17 14:17:24 absol pppd[4854]: pppd 2.4.4 started by root, uid 0
Dec 17 14:17:24 absol pppd[4854]: connect(8.48): No such device
Dec 17 14:17:24 absol pppd[4854]: Exit.

Dec 17 14:17:26 absol rc-scripts: Failed to start the PPP daemon


Without the patch:

Dec 17 14:19:19 absol pppd[4847]: Plugin pppoatm.so loaded.
Dec 17 14:19:19 absol pppd[4847]: PPPoATM plugin_init
Dec 17 14:19:19 absol pppd[4847]: PPPoATM setdevname_pppoatm - SUCCESS:8.48
Dec 17 14:19:19 absol pppd[4848]: pppd 2.4.4 started by root, uid 0
Dec 17 14:19:19 absol pppd[4848]: using channel 1
Dec 17 14:19:19 absol pppd[4848]: Using interface ppp0
Dec 17 14:19:19 absol pppd[4848]: Connect: ppp0 <--> 8.48


Best regards,
Nicolas Kaiser
