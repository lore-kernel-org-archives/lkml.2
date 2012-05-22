Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab2EVR0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:26:51 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:34821 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2EVR0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:26:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
References: <m11unyn70b.fsf@fess.ebiederm.org>
	<m1likyz4mh.fsf@fess.ebiederm.org>
	<201205211125.GAF21848.tOFSVFHJLOQFMO@I-love.SAKURA.ne.jp>
Date: Tue, 22 May 2012 11:26:37 -0600
In-Reply-To: <201205211125.GAF21848.tOFSVFHJLOQFMO@I-love.SAKURA.ne.jp>
	(Tetsuo Handa's message of "Mon, 21 May 2012 11:25:01 +0900")
Message-ID: <87ipfoxh2q.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18nMuMoJNElarZi4PsNK0daIVaHLcjVW6Q=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4733]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
X-Spam-Relay-Country: 
Subject: Re: Please include user-namespace.git in linux-next
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> I think something is wrong with commit e1c972b6 "userns: Add negative depends
> on entries to avoid building code that is userns unsafe".

My apologies for the delayed reply.

> With gcc 4.4.6 on CentOS 6.2, "make allnoconfig" where UIDGID_CONVERTED should
> become y is showing
>
> Symbol: USER_NS [=n]
> Type  : boolean
> Prompt: User namespace (EXPERIMENTAL)
>   Defined at init/Kconfig:880
>   Depends on: NAMESPACES [=y] && EXPERIMENTAL [=n] && UIDGID_CONVERTED [=n]
>   Location:
>     -> General setup
>       -> Namespaces support (NAMESPACES [=y])
>   Selects: UIDGID_STRICT_TYPE_CHECKS [=n]
>
> .
> I think this commit meant "!FOO" rather than "FOO = n",
> othwewise there is no way for linux-next-20120518 to enable USER_NS.
> ----------------------------------------
> PATCH: user_ns: Fix wrong dependency in UIDGID_CONVERTED.

It turns out to be more subtle than that. The issue is that I have
"depends on USB_DEVICEFS = n" and then USB_DEVICEFS was removed.

"depends on FOO = n" is the only way I found that will succeed when in
verifying that FOO is neither enabled nor modular.  "depends on !FOO"
appears to succeed when FOO = m which is not at all what I want.

After both trees are merged I will have to remove that
"depends on USB_DEVICEFS = n" dependency.

I can't see any possible way to do hand this before then.

Eric
