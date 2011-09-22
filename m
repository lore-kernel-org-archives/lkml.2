Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1IVHZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 03:25:48 -0400
Received: from mga05.intel.com ([192.55.52.89]:43335 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751647Ab1IVHZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 03:25:46 -0400
MIME-Version: 1.0
In-Reply-To: <1316625330.25495.66.camel@moss-pluto>
References: <1316522254-23193-1-git-send-email-jarkko.sakkinen@intel.com>
	<1316625330.25495.66.camel@moss-pluto>
Date: Thu, 22 Sep 2011 10:25:44 +0300
Message-ID: <CADjiTvCQp5EHigC60YD5HzshzaUaKWKhPc95WC2sBAjFcGmUUQ@mail.gmail.com>
Subject: Re: [PATCH] Smack: Use secureexec with SMACK64EXEC
From: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 8:15 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> bprm->unsafe isn't private to your security module, unlike e.g.
> bprm->cred->security.  And it isn't intended to indicate that a
> secureexec is being performed, but instead as an indicator that a
> credential-changing exec may be unsafe.  Which you presently ignore.
> Defining and setting a new flag in it will have interesting side
> effects, e.g. consider cap_bprm_secureexec, not to mention being a
> layering violation and a source of future conflicts.
>
> Why can't your bprm_secureexec hook just test isp->smk_task directly?
> It can reach it from the bprm.  Or if you don't like testing it twice,
> then you could always add a flag to your struct referenced by
> bprm->cred->security, i.e. the smack_task struct.

Thank you. You're absolutely right on this and yes, I can
safely just use isp->smk_task. No need for that flag.

BTW, do you know why AppArmor does use similar flag
AA_SECURE_X_NEEDED?

> BTW, there is a lot more to do if you want SMACK64EXEC to be safe.

Can you open up this a bit?

/Jarkko
