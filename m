Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2ISF6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:58:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47591 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2ISF6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:58:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Feng Hong <hongfeng@marvell.com>
Cc: "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "gorcunov\@openvz.org" <gorcunov@openvz.org>,
        "keescook\@chromium.org" <keescook@chromium.org>,
        "serge.hallyn\@canonical.com" <serge.hallyn@canonical.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1348025233-13412-1-git-send-email-hongfeng@marvell.com>
	<87fw6eaac4.fsf@xmission.com>
	<E62404B31D39064FBDD0B843ADF05A7D2D395FC749@SC-VEXCH4.marvell.com>
Date: Tue, 18 Sep 2012 22:58:24 -0700
In-Reply-To: <E62404B31D39064FBDD0B843ADF05A7D2D395FC749@SC-VEXCH4.marvell.com>
	(Feng Hong's message of "Tue, 18 Sep 2012 22:07:04 -0700")
Message-ID: <87a9wma70f.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+F6Xi315yREzRkAM+10GFZD6Wq7UKfqcU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Feng Hong <hongfeng@marvell.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] poweroff: fix bug in orderly_poweroff
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng Hong <hongfeng@marvell.com> writes:

> Hi, Eric
>
> 1. We are developing on an Android phone platform, we use thermal
> framework to monitor the temperature, when the temperature above like
> 110 degree, thermal framework will use orderly_shutdown to shutdown
> phone, however, on Android platform there is no " /sbin/poweroff " cmd
> ready . Then we want "fail ret" to trigger force shutdown (use
> kernel_power_off), but always we get "suc ret"

> 2. Here the caller just wait for "poweroff" userspace application, if
> it block the called, then it's the "poweroff" problem itself

> 3. As in the original orderly_shutdown design, we must get the right
> "ret", if this ret is always "0", then it obey orderly_poweroff design
> goal. Step 2: force shutdown is always useless code. 

That sounds like a clear case that we need to change it to
UMH_WAIT_EXEC.

Changing it to UMH_WAIT_PROC seems much more dangerous.

Eric
