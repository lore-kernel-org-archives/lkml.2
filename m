Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab1DMAo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:44:59 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:39199 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab1DMAo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DSxQXflefb8u76jm8q6YDyUppO+cmsW0MiTrB/+AhSicdBWePWfFk6s0ZXdewYjWyp
         Z3l8Htdwt2QRPkV4o2ko37CUwbzmTSWjvipAey/9euMuqjvS7qZRKWvfeDGCCZrjV++x
         rU0clHFLZwwIvDg/YLAAPb3hTJS0eyYu1YPbE=
Message-ID: <4DA4F201.9050609@gmail.com>
Date: Tue, 12 Apr 2011 17:44:49 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Balbir Singh <balbir@in.ibm.com>
Subject: =?windows-1252?Q?Re=3A_=5BRFC=5DDocumentation=3Aaccounting=3Ag?=
 =?windows-1252?Q?etdelays=2Ec_Fix=3A_warning=3A_variable_=91i=92?=
 =?windows-1252?Q?_set_but_not_used?=
References: <1302019370-7101-1-git-send-email-justinmattock@gmail.com> <20110412172627.4e9c4339.akpm@linux-foundation.org>
In-Reply-To: <20110412172627.4e9c4339.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 05:26 PM, Andrew Morton wrote:
> On Tue,  5 Apr 2011 09:02:50 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> Keep in mind there is another warning with this file, but need am unsure what might be the best solution:
>> Documentation/accounting/getdelays.c: In function ___get_family_id___:
>> Documentation/accounting/getdelays.c:172:14: warning: variable ___rc___ set but not used [-Wunused-but-set-variable]
>
> this?

there was two warnings with that one..(or atleast that what I am seeing 
over here).

>
>
> Subject: Documentation/accounting/getdelays.c: handle sendto() failures
> From: Andrew Morton<akpm@linux-foundation.org>
>
> Documentation/accounting/getdelays.c: In function `get_family_id':
> Documentation/accounting/getdelays.c:172:14: warning: variable `rc' set but not used [-Wunused-but-set-variable]
>
> Reported-by: "Justin P. Mattock"<justinmattock@gmail.com>
> Cc: Balbir Singh<balbir@in.ibm.com>
> Signed-off-by: Andrew Morton<akpm@linux-foundation.org>
> ---
>
>   Documentation/accounting/getdelays.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-handle-sendto-failures Documentation/accounting/getdelays.c
> --- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-handle-sendto-failures
> +++ a/Documentation/accounting/getdelays.c
> @@ -177,6 +177,8 @@ static int get_family_id(int sd)
>   	rc = send_cmd(sd, GENL_ID_CTRL, getpid(), CTRL_CMD_GETFAMILY,
>   			CTRL_ATTR_FAMILY_NAME, (void *)name,
>   			strlen(TASKSTATS_GENL_NAME)+1);
> +	if (rc<  0)
> +		return 0;	/* sendto() failure? */
>
>   	rep_len = recv(sd,&ans, sizeof(ans), 0);
>   	if (ans.n.nlmsg_type == NLMSG_ERROR ||
> _
>
>

