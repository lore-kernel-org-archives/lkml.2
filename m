Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab3AITRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:17:08 -0500
Received: from nm30.access.bullet.mail.mud.yahoo.com ([66.94.237.95]:21065
	"EHLO nm30.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932367Ab3AITRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:17:07 -0500
X-Yahoo-Newman-Id: 223038.24480.bm@smtp104.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wEaod30VM1lrScgdPqyHAfTYXKn5MRXqkIE6AMlD3DRuOsP
 XWqXQz68l_14qMy7CrD5wfgZKtGvzqz4MF.UrGgXY9RxWWvQl21.SKClQpjj
 vFo.ldYcgu6HpcuRkoTvCePNkzwB6_YoW0LHrjcTEo0_BbKzyZAFnLTz66we
 o4JAhbQf8dXRRFa3MTHzWJu3hz5vACiul1A3INa6XCQ.xr7vcxbSwsFNk_12
 3un8KLU0C.0FxI3fD4Qy1Kb2vdpxa4D4LfCq2EErLVvUezAEyoVavKSGPbCB
 yvHiDw7lqgOPt0KxlyQi_etrBx9wff_en4zy4O0cSD6v5pg53VI5mZ228DyS
 lb7WUGe_xl8IrvhfqfuTSr7iDjZLNekaKfPRszNwR1LYFzXYqYjtrzczRPcL
 QB.SLhOVLhqXDSLiD1iRzjo4BiEXbb9609bJkied_kgUw0Fm7gQBwDx27LwS
 RTe2y5fCVD9K15xONEDbq.fZVaPa_fevzRZLu7rxIGfhN8tcDAJYfSiauI7X
 410rmJ8XWA.U8L6FI.CuIiK3ug6._5HIT0ZNdVjhN3MxyfGUzjHk8Gg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EDC242.5070508@schaufler-ca.com>
Date: Wed, 09 Jan 2013 11:17:22 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rafal Krypa <r.krypa@samsung.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: add missing support for transmute bit in smack_str_from_perm()
References: <1354030147-32577-1-git-send-email-r.krypa@samsung.com>
In-Reply-To: <1354030147-32577-1-git-send-email-r.krypa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 7:29 AM, Rafal Krypa wrote:
> This fixes audit logs for granting or denial of permissions to show
> information about transmute bit.
>
> Targeted for git://git.gitorious.org/smack-next/kernel.git
>
> Signed-off-by: Rafal Krypa <r.krypa@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#stage-for-3.9


> ---
>  security/smack/smack_access.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index db14689..2e397a8 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -252,6 +252,8 @@ static inline void smack_str_from_perm(char *string, int access)
>  		string[i++] = 'x';
>  	if (access & MAY_APPEND)
>  		string[i++] = 'a';
> +	if (access & MAY_TRANSMUTE)
> +		string[i++] = 't';
>  	string[i] = '\0';
>  }
>  /**

