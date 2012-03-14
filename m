Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398Ab2CNSka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:40:30 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53842 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2CNSk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:40:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jesse Gross <jesse@nicira.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Justin Pettit <jpettit@nicira.com>
References: <1331690897-26496-1-git-send-email-jesse@nicira.com>
Date: Wed, 14 Mar 2012 11:43:48 -0700
In-Reply-To: <1331690897-26496-1-git-send-email-jesse@nicira.com> (Jesse
	Gross's message of "Tue, 13 Mar 2012 19:08:17 -0700")
Message-ID: <m1zkbjauqj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/h2F/YvZ0aalm5+PfyHM7DgsO+B/Z+9RQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.5 XMGappySubj_01 Very gappy subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jesse Gross <jesse@nicira.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] proc-ns: Use d_set_d_op() API to set dentry ops in proc_ns_instantiate().
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Gross <jesse@nicira.com> writes:

> From: Pravin B Shelar <pshelar@nicira.com>
>
> Use d_set_d_op() so that DCACHE_OP_* flags are set correctly which fixes ns
> cleanup path i.e. `ip netns delete `.
>
> This issue exists back to 3.0.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Jesse thanks for picking this up and giving this a push.  This is most
definitely the right fix and it most definitely solves issues.   Somehow
this fix got lost when I sent it to Linus the first time.

> CC: Eric W. Biederman <ebiederm@xmission.com>
> Reported-by: Justin Pettit <jpettit@nicira.com>
> Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
> Signed-off-by: Jesse Gross <jesse@nicira.com>
> ---
>  fs/proc/namespaces.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
> index 27da860..3551f1f 100644
> --- a/fs/proc/namespaces.c
> +++ b/fs/proc/namespaces.c
> @@ -53,7 +53,7 @@ static struct dentry *proc_ns_instantiate(struct inode *dir,
>  	ei->ns_ops    = ns_ops;
>  	ei->ns	      = ns;
>  
> -	dentry->d_op = &pid_dentry_operations;
> +	d_set_d_op(dentry, &pid_dentry_operations);
>  	d_add(dentry, inode);
>  	/* Close the race of the process dying before we return the dentry */
>  	if (pid_revalidate(dentry, NULL))
