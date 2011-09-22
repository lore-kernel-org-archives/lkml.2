Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab1IVN25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:28:57 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:63671 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1IVN2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:28:54 -0400
Subject: Re: [PATCH] Smack: Use secureexec with SMACK64EXEC
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <CADjiTvCQp5EHigC60YD5HzshzaUaKWKhPc95WC2sBAjFcGmUUQ@mail.gmail.com>
References: <1316522254-23193-1-git-send-email-jarkko.sakkinen@intel.com>
	 <1316625330.25495.66.camel@moss-pluto>
	 <CADjiTvCQp5EHigC60YD5HzshzaUaKWKhPc95WC2sBAjFcGmUUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Thu, 22 Sep 2011 09:28:48 -0400
Message-ID: <1316698128.5731.42.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 10:25 +0300, Sakkinen, Jarkko wrote:
> On Wed, Sep 21, 2011 at 8:15 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > bprm->unsafe isn't private to your security module, unlike e.g.
> > bprm->cred->security.  And it isn't intended to indicate that a
> > secureexec is being performed, but instead as an indicator that a
> > credential-changing exec may be unsafe.  Which you presently ignore.
> > Defining and setting a new flag in it will have interesting side
> > effects, e.g. consider cap_bprm_secureexec, not to mention being a
> > layering violation and a source of future conflicts.
> >
> > Why can't your bprm_secureexec hook just test isp->smk_task directly?
> > It can reach it from the bprm.  Or if you don't like testing it twice,
> > then you could always add a flag to your struct referenced by
> > bprm->cred->security, i.e. the smack_task struct.
> 
> Thank you. You're absolutely right on this and yes, I can
> safely just use isp->smk_task. No need for that flag.
> 
> BTW, do you know why AppArmor does use similar flag
> AA_SECURE_X_NEEDED?

No idea.  Sounds wrong to me.

> > BTW, there is a lot more to do if you want SMACK64EXEC to be safe.
> 
> Can you open up this a bit?

I'd suggest studying the SELinux bprm hooks. You don't necessarily have
to do everything we do, but you at least should understand why we do it
and what tradeoff you are making by not doing it.

-- 
Stephen Smalley
National Security Agency

