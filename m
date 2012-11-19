Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2KSJ16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:27:58 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50572 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab2KSJ14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:27:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
        Serge Hallyn <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <8739097bkk.fsf@xmission.com>
	<1353083750-3621-1-git-send-email-ebiederm@xmission.com>
	<1353083750-3621-9-git-send-email-ebiederm@xmission.com>
	<50A9F7DE.60807@cn.fujitsu.com>
Date: Mon, 19 Nov 2012 01:27:41 -0800
In-Reply-To: <50A9F7DE.60807@cn.fujitsu.com> (Gao feng's message of "Mon, 19
	Nov 2012 17:11:58 +0800")
Message-ID: <87wqxij62a.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX18CLizbtVQ94fgHKD4z+q9Tjn08MFkcL6Y=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gao feng <gaofeng@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 09/11] pidns: Add setns support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gao feng <gaofeng@cn.fujitsu.com> writes:

> 于 2012年11月17日 00:35, Eric W. Biederman 写道:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> - Pid namespaces are designed to be inescapable so verify that the
>>   passed in pid namespace is a child of the currently active
>>   pid namespace or the currently active pid namespace itself.
>> 
>>   Allowing the currently active pid namespace is important so
>>   the effects of an earlier setns can be cancelled.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>
> Hi Eric
>
> I noticed that,after we call setns to change task's pidns to container A's pidns.
> we can't see this task in container A's proc filesystem.
>
> Is this what we expected?

Only children move to the new pid namespace so yes.

Any other semantic requires ugly races with changing the pid of an
existing process.

Eric

