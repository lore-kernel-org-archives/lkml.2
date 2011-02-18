Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1BRDF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:05:28 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43079 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1BRDF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:05:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150316.GC26395@mail.hallyn.com>
Date: Thu, 17 Feb 2011 19:05:21 -0800
In-Reply-To: <20110217150316.GC26395@mail.hallyn.com> (Serge E. Hallyn's
	message of "Thu, 17 Feb 2011 15:03:16 +0000")
Message-ID: <m11v369h5a.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19oO/lRg4flb3T7oWpGPTbKj7fa56WgX2A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/9] allow sethostname in a container
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>


> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  kernel/sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 18da702..7a1bbad 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1177,7 +1177,7 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
>  	int errno;
>  	char tmp[__NEW_UTS_LEN];
>  
> -	if (!capable(CAP_SYS_ADMIN))
> +	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
>  		return -EPERM;
>  	if (len < 0 || len > __NEW_UTS_LEN)
>  		return -EINVAL;
