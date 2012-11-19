Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2KSV17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 16:27:59 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:43676 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2KSV15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 16:27:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <87lidx8wbo.fsf@xmission.com>
	<1353337961-12962-1-git-send-email-ebiederm@xmission.com>
	<1353337961-12962-12-git-send-email-ebiederm@xmission.com>
	<20121119180322.GC1883@serge-ThinkPad-X130e>
	<87fw451m5i.fsf@xmission.com> <20121119210153.GA11904@sergelap>
	<877gphz4d9.fsf@xmission.com> <20121119211912.GA12388@sergelap>
Date: Mon, 19 Nov 2012 13:27:45 -0800
In-Reply-To: <20121119211912.GA12388@sergelap> (Serge Hallyn's message of
	"Mon, 19 Nov 2012 15:19:12 -0600")
Message-ID: <87y5hxxoz2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/OPC51/anvsNdWt9IqDC72jS1SLW5Ffdk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 12/16] userns: For /proc/self/{uid, gid}_map derive the lower userns from the struct file
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@canonical.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> In practice when playing around it is the difference between.
>> unshare -U /bin/bash
>> echo 0 1000 1 > /proc/self/uid_map
>> 
>> And the need to pre-plan something.  You can set the uid_map from the
>> parent in a shell script but it is a real pain.  So for just messing
>> around allowing seq_ns == ns is a real advantage.
>
> Heh, ok - I almost always want >1 uid mapped, but I can see the
> advantage.

The original plan called for an upcall and >1 uid mapped.  But yeah
that is something else again.

> Thanks.
>
> I don't recall whether I put this in originally, but
>
> Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
>
>> > I also wonder if -EINVAL would be a more appropriate choice here.
>> > We're trying to keep things sane, rather than saying "not allowed"
>> > for its own sake.
>> 
>> A different error code might be better.
>
> I suppose strictly speaking (looking at errno-base.h) it would be
> EBADF?

Definitely not EBADF.  EBADF is the error code for operating on a closed
file descriptor.

I want a ENOTALLOWED. Anyway.

Eric

