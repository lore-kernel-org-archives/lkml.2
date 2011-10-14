Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1JNQL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:11:26 -0400
Received: from nm16.access.bullet.mail.mud.yahoo.com ([66.94.237.217]:26506
	"HELO nm16.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754396Ab1JNQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:11:25 -0400
X-Yahoo-Newman-Id: 586988.34597.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: p0PkK7MVM1nglFovYVoiUb0etBaJQQXDBpVUQgIlhZ96ZDf
 reeCPaPRZZZ9tjefIYGog7tdZTtsNw.FDUZGiFipHGTfGi.g30_6Zx9H5nXV
 zDU0u8dxUSyH7y.j97BTU0U3FczCKqO_p7aEEVHpQ3f3hBPgSYtMODgRmInG
 TRIOoOGoE22AfFhQ6UFpoVKU_uE01gYCwdm9Tjc0nqa5tNBEfsmwxJzM_0Wi
 SBaqRL8hRH2DLqjXXAdzldeNfwc4fqd8hkFHibWRsG4rXNIlu7IXUS6v3Tmt
 fDHlN3HzRYWVlxVRp.dftUR0iHjrEG4x5y_ZCHtykB5pQV93LTxy81M.6Kn0
 ZML.4fHSmDGdipYln73SA9CD8yA2IpAqH9hqMPCxNMdAOwYIzcfnAH8u8yQY
 2Utz2w6ZdafEimXhBVX5Us3aw5u0Vy64Hsmgt9o7LrGbnrwTalvR_rUVmKuw
 fXhTFP2PwWPiG_lUr0UJGLIbGDhpMxzAzzWeKIFlypRY-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E985DA8.80608@schaufler-ca.com>
Date: Fri, 14 Oct 2011 09:04:56 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>,
        James Morris <jmorris@namei.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: compilation fix
References: <1318587384-2737-1-git-send-email-jarkko.j.sakkinen@gmail.com>
In-Reply-To: <1318587384-2737-1-git-send-email-jarkko.j.sakkinen@gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 3:16 AM, Jarkko Sakkinen wrote:
> On some build configurations PER_CLEAR_ON_SETID symbol was not
> found when compiling smack_lsm.c. This patch fixes the issue by
> explicitly doing #include <linux/personality.h>.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.j.sakkinen@gmail.com>

Applied to git://gitorious.org/smack-next/kernel.git#master

James, can you pull for security testing please?

commit 16014d87509e26d6ed6935adbbf437a571fb5870

> ---
>  security/smack/smack_lsm.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index d55b991..7db62b4 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -35,6 +35,7 @@
>  #include <linux/audit.h>
>  #include <linux/magic.h>
>  #include <linux/dcache.h>
> +#include <linux/personality.h>
>  #include "smack.h"
>  
>  #define task_security(task)	(task_cred_xxx((task), security))

