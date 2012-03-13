Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab2CMSYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:24:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46910 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab2CMSYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:24:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: DuanZhenzhong <zhenzhong.duan@oracle.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1329989047-20378-1-git-send-email-zhenzhong.duan@oracle.com>
	<4F5EBAA7.50709@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Mar 2012 11:27:30 -0700
In-Reply-To: <4F5EBAA7.50709@oracle.com> (DuanZhenzhong's message of "Tue, 13
	Mar 2012 11:10:31 +0800")
Message-ID: <m1r4wwe4q5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18kvuhhL1B+gTlQCTcGLO+3MN4K01SY2qA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  3.0 XMGappySubj_01 Very gappy subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0113]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;DuanZhenzhong <zhenzhong.duan@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kexec: add further check to crashkernel
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DuanZhenzhong <zhenzhong.duan@oracle.com> writes:

> From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>
> When add crashkernel=2M-256M, kernel don't give any warning.
> This is misleading sometimes.

That seems reasonable.

Andrew do you want to carry this one.  I don't have a good tree to stash
this in.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
> kernel/kexec.c |    4 ++++
> 1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 7b08867..0a6d147 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1359,6 +1359,10 @@ static int __init parse_crashkernel_simple(char 		*cmdline,
>
> 	if (*cur == '@')
> 		*crash_base = memparse(cur+1, &cur);
> +	else if (*cur != ' ' && *cur != '\0') {
> +		pr_warning("crashkernel: unrecognized char\n");
> +		return -EINVAL;
> +	}
>
> 	return 0;
> }
> -- 1.7.3
