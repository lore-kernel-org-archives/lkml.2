Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0LRBGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:06:12 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:14050
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756487Ab0LRBGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:06:08 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK1432N98dNzz1202hzz8275bhz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D0C08E0.4040908@am.sony.com>
Date: Fri, 17 Dec 2010 17:05:36 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/5] sched: Change the ttwu success details
References: <20101216145602.899838254@chello.nl> <20101216150920.866959114@chello.nl>
In-Reply-To: <20101216150920.866959114@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/10 06:56, Peter Zijlstra wrote:
> try_to_wake_up() would only return a success when it would have to
> place a task on a rq, change that to every time we change p->state to
> TASK_RUNNING, because that's the real measure of wakeups.
> 
> This results in that success is always true for the tracepoint, so
> remove its success argument.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Looks good to me, so far.  But I still I have a few more places that call
try_to_wake_up() to validate.

Acked-by: Frank Rowand <frank.rowand@am.sony.com>

