Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967249Ab2EQR2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:28:24 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55223 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2EQR2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:28:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120516164323.GA15140@redhat.com> (Oleg Nesterov's message of
	"Wed, 16 May 2012 18:43:24 +0200")
References: <20120516193052.4af4ee85feb4a36b936b74df@canb.auug.org.au>
	<20120516164323.GA15140@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 17 May 2012 11:28:08 -0600
Message-ID: <871umizphz.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18ChXacsCmiEt9nBioIcXLAxVIRV6oCu1w=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: linux-next: manual merge of the akpm with the  tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 05/16, Stephen Rothwell wrote:
>>
>> --- a/kernel/exit.c
>> +++ b/kernel/exit.c
>> @@@ -1218,7 -1218,7 +1218,7 @@@ static int wait_task_zombie(struct wait
>>   	unsigned long state;
>>   	int retval, status, traced;
>>   	pid_t pid = task_pid_vnr(p);
>> - 	uid_t uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
>>  -	uid_t uid = task_uid(p);
>> ++	uid_t uid = from_kuid_munged(current_user_ns(), task_uid(p));
>>   	struct siginfo __user *infop;
>
> Thanks Stephen, the fix looks correct.
>
> Oleg.

Yes.  That looks good.

I'm not quite certain of my thinking there was.  The two idioms are
equivalent.  I suspect I confused task_uid(p) which is fine with
task_user_ns(p) which is only safe under the rtnl lock and should
probably be removed as a helper function because it isn't used that way.

Eric
