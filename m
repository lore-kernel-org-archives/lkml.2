Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab1IVDds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 23:33:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:16754 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab1IVDdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 23:33:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="52330630"
From: "Ryan Ware" <ware@linux.intel.com>
To: "'Stephen Smalley'" <sds@tycho.nsa.gov>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
Cc: "'Casey Schaufler'" <casey@schaufler-ca.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>
References: <1316522254-23193-1-git-send-email-jarkko.sakkinen@intel.com> <1316625330.25495.66.camel@moss-pluto>
In-Reply-To: <1316625330.25495.66.camel@moss-pluto>
Subject: RE: [PATCH] Smack: Use secureexec with SMACK64EXEC
Date: Thu, 22 Sep 2011 12:33:40 +0900
Message-ID: <014c01cc78d8$6e62a790$4b27f6b0$@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHumOaQoXcEaTtAndHV6gpTErxFXADEHtzjlQ5dypA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> 
> 
> bprm->unsafe isn't private to your security module, unlike e.g.
> bprm->cred->security.  And it isn't intended to indicate that a
> secureexec is being performed, but instead as an indicator that a
> credential-changing exec may be unsafe.  Which you presently ignore.
> Defining and setting a new flag in it will have interesting side effects,
> e.g. consider cap_bprm_secureexec, not to mention being a layering
> violation and a source of future conflicts.
> 
> Why can't your bprm_secureexec hook just test isp->smk_task directly?
> It can reach it from the bprm.  Or if you don't like testing it twice,
> then you could always add a flag to your struct referenced by
> bprm->cred->security, i.e. the smack_task struct.
> 
> BTW, there is a lot more to do if you want SMACK64EXEC to be safe.

Thanks for the feedback Stephen.  Could you be more detailed on what else you feel needs to be in place to make SMACK64EXEC safe?

Ryan

