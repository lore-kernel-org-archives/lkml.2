Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab2JWNOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:14:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35767 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab2JWNOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:14:31 -0400
Date: Tue, 23 Oct 2012 15:14:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, tony.luck@intel.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in
 cmci_rediscover().
Message-ID: <20121023131428.GA26756@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Tang Chen <tangchen@cn.fujitsu.com>, tony.luck@intel.com,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	laijs@cn.fujitsu.com, wency@cn.fujitsu.com, x86@kernel.org,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
 <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com>
 <20121019164045.GE11958@aftab.osrc.amd.com>
 <5084AB10.7010807@cn.fujitsu.com>
 <20121022101442.GB8352@liondog.tnic>
 <50860711.10807@cn.fujitsu.com>
 <20121023095234.GA22715@liondog.tnic>
 <50866EBB.2010507@cn.fujitsu.com>
 <20121023102008.GB24656@liondog.tnic>
 <508672B9.8010303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <508672B9.8010303@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 06:34:33PM +0800, Miao Xie wrote:
> So we add this WARN_ON_ONCE(), it can tell the developers that there
> is something wrong in the code if it is triggered.

First of all, the WARN_ON_ONCE will fire only once during system
lifetime (well, doh, of course) which diminishes debuggability
significantly and then, the only other place which deals with
CPU_POST_DEAD is kernel/stop_machine.c:cpu_stop_cpu_callback.

So, just to sum up and finish this fruitless discussion:
cmci_rediscover() correctly ignores the dying cpu and there's
*absolutely* no need to warn.

If you still think there is, you have to come up with a concrete example
and a way for others to reproduce it. Then we can talk.

End of story.

-- 
Regards/Gruss,
Boris.
