Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab1BCFU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 00:20:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45226 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1BCFU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 00:20:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Cc: kosaki.motohiro@jp.fujitsu.com, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <20110203121302.93B9.A69D9226@jp.fujitsu.com>
References: <20110203020528.GA21603@redhat.com> <20110203121302.93B9.A69D9226@jp.fujitsu.com>
Message-Id: <20110203141850.93C2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Feb 2011 14:20:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> AFAIK, kexec is used sneak rebooting way when the system face unexpected
> scenario on some devices. (Some embedded is running very long time, then 
> it can't avoid memory bit corruption. all of reset is a last resort. 
> and a vendor gather logs at periodically checkback).
> 
> The main purpose of to introduce KMSG_DUMP_KEXEC is to be separate it
> from KMSG_DUMP_PANIC. At kmsg_dump() initial patch, KMSG_DUMP_PANIC 
> is always called both kdump is configured or not. But it's no good idea
> the same log is to be appeared when both kexec was successed and failured.
> Moreover someone don't want any log at kexec phase. They only want logs
> when real panic (ie kexec failure) route. Then, I've separated it to two.
> Two separated argument can solve above both requreiment.

A bit additional explanation, An original patch have kmsg_dump(KMSG_DUMP_PANIC)
callsite at following point. I didn't think it makes either embedded or 
kdump folks happiness. Thus I moved it after crash_kexec().


---------------------------------------------------------------------
@@ -74,6 +75,7 @@ NORET_TYPE void panic(const char * fmt, ...)
        dump_stack();
 #endif

+       kmsg_dump(KMSG_DUMP_PANIC);
        /*
         * If we have crashed and we have a crash kernel loaded let it handle
         * everything else.
         * Do we want to call this before we try to display a message?
         */
        crash_kexec(NULL);
---------------------------------------------------------------------



