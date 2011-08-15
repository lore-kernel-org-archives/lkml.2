Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1HOJpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 05:45:12 -0400
Received: from lo.gmane.org ([80.91.229.12]:39828 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1HOJpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 05:45:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: scream <scream@wdk.dn.ua>
Subject: Re: [BUG] null-pointer in =?utf-8?b?dGFza19ycV9sb2Nr?= (2.6.35 to 3.0-rc7)
Date: Mon, 15 Aug 2011 07:22:29 +0000 (UTC)
Message-ID: <loom.20110815T091606-71@post.gmane.org>
References: <4E25E2F5.7090807@dasr.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 89.105.229.75 (Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Laabs <kernelml <at> dasr.de> writes:

> 
> Hi,
> reloading an apache httpd can crash the kernel since 2.6.35.
> It seems that tasks are removed between creating the task-list and
> calling wake_up_sem_queue_do in freeary. The pointers to the
> task_struct elements end up in try_to_wake_up and sometimes contain
> 0x0 there.


Had the same in production.

Linux version 2.6.35-22-server (buildd@allspice) (gcc version 4.4.5 
(Ubuntu/Linaro 4.4.4-14ubuntu4) ) #33-Ubuntu SMP Sun Sep 19 20:48:58 UTC 2010 
(Ubuntu 2.6.35-22.33-server 2.6.35.4)

 Apache/2.2.16 (Ubuntu) PHP/5.3.3-1ubuntu9 with Suhosin-Patch mod_ssl/2.2.16 
OpenSSL/0.9.8o

Appeared 2 times after apache2 reload during cron daily jobs.


