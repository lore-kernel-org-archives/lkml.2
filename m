Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1I2I1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:27:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:12845 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab1I2I1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:27:10 -0400
Date: Thu, 29 Sep 2011 11:26:57 +0300 (EEST)
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
X-X-Sender: jsakkine@jsakkine-mobl
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: fix domain transfer issues
In-Reply-To: <1317222904.20139.20.camel@moss-pluto>
Message-ID: <alpine.DEB.2.02.1109291109070.3006@jsakkine-mobl>
References: <1317206909-24443-1-git-send-email-jarkko.sakkinen@intel.com> <1317222904.20139.20.camel@moss-pluto>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Sep 2011, Stephen Smalley wrote:
> Did I miss something or did you find a rationale for using bprm->unsafe
> in this manner?  It isn't private to your security module yet you are
> claiming a bit for your own private use without reserving it in any way
> globally (consider implications for any future stacking), and setting
> new bits in it will have side effects on the capabilities logic.  I
> already mentioned this on your first patch and you seemed to acknowledge
> it then.  Pass it via bprm->cred->security if you need to pass it as a
> flag, or re-test the condition in the secureexec hook otherwise.

You got your point. I'll add smk_flags field to
the struct task_smack (our task security blob).

> Why not just:
> 	if (bprm->unsafe)
> 		return -EPERM;
> if you aren't going to distinguish them via permission checks or
> anything?

I guess my purpose was to leave those visible because
plan is to add permission checks at least for the
ptrace case in the future. Now that I think of it,
it does not justify their existence in the code.
I'll revise this.

Even in the current form, there should be check that
you described to protect this code against situation
where new LSM_UNSAFE flag is added and support has not
yet been implemented to Smack.

>
> I take it you've decided you don't need any of the other checks or
> sanitization applied by SELinux?

MNT_NOSUID should be checked. Also, I'll plan to
implement permission check for ptrace but in the
scope of this patch.

Thanks for informative reply!

/Jarkko
