Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1BCAzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:55:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54110 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab1BCAzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:55:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Cc: kosaki.motohiro@jp.fujitsu.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <20110131225939.GH11974@redhat.com>
References: <20110131225939.GH11974@redhat.com>
Message-Id: <20110203094715.939C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Feb 2011 09:55:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi,
> 
> I noticed following commit which hooks into crash_kexec() for calling
> kmsg_dump().
> 
> I think it is not a very good idea to pass control to modules after
> crash_kexec() has been called. Because modules can try to take locks
> or try to do some other operations which we really should not be doing
> now and fail kdump also. The whole design of kdump is built on the
> fact that in crashing kernel we do minimal thing and try to make 
> transition to second kernel robust. Now with this hook, kmsg dumper
> breaks that assumption.

I guess you talked about some foolish can shoot their own foot. if so,
Yes. Any kernel module can make kernel panic or more disaster result.


> Anyway, if an image is loaded and we have setup to capture dump also
> why do we need to save kmsg with the help of an helper. I am assuming
> this is more of a debugging aid if we have no other way to capture the
> kernel log buffer. So if somebody has setup kdump to capture the
> vmcore, why to call another handler which tries to save part of the
> vmcore (kmsg) separately.

No.

kmsg_dump() is desingned for embedded. and some embedded devices uses
kexec for non dumping purpose. (Have you seen your embedded devices 
show "Now storing dump image.." message?)

Anyway, you can feel free to avoid to use ksmg_dump().




