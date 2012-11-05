Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2KEVOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:14:05 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58725 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2KEVOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:14:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <20121105163810.GJ14789@redhat.com> <87r4o7alod.fsf@xmission.com>
	<20121105201825.GM14789@redhat.com>
Date: Mon, 05 Nov 2012 13:13:55 -0800
In-Reply-To: <20121105201825.GM14789@redhat.com> (Aristeu Rozanski's message
	of "Mon, 5 Nov 2012 15:18:25 -0500")
Message-ID: <87k3tz4uss.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/0JE43I6NmXQeF8sRJlMp1Z+YClJ3PuAI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2745]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Aristeu Rozanski <aris@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] coredump: run the coredump helper using the same namespace as the dead process
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aristeu Rozanski <aris@redhat.com> writes:

> On Mon, Nov 05, 2012 at 11:34:26AM -0800, Eric W. Biederman wrote:
>> I would argue that you very much need to define what it means to have a
>> per container core dump at the same time as you argue this.
>> 
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> Running in a namespace different than whoever set the core dump
>> pattern/helper makes core dump helpers much more attackable.  With this
>> patch and a little creativity I expect I can get root to write to
>> whatever file I would like.  Since I also control the content of what is
>> going into that file.... This design seems emintely exploitable.
>
> Understood. Indeed this is bad design. Having it tied to the mount
> namespace of the process setting the pattern/helper, therefore any
> process crashing under the same mount namespace would use the same
> pattern/helper? 

Other than knowing we need an intuitive and predictable set of
namespaces that will be for the core dumping application I don't
know what the proper design is at this time.

>> Furthermore not all namespaces are pointed at by nsproxy, so even
>> for it's original design this patch is buggy.
>
> is it userns? I just assumed it wasn't there yet because it's being
> worked on.

userns is certainly one case.  The user namespace has no reason to
appear in nsproxy and plenty of good reasons connected with not
duplicating data for not appearing in nsproxy.

>> I do think supporting a per container coredump setting makes a lot of
>> sense but I do not think this patch is the way to do it.
>
> I understand, thanks for the time reviewing it.

Eric
