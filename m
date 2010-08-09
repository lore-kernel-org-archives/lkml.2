Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0HIOWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:22:21 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:47047 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756199Ab0HIOWT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:22:19 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Aug 2010 10:22:19 EDT
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Julia Lawall <julia@diku.dk>, "Moore, Eric" <Eric.Moore@lsi.com>,
        "Support, Software" <support@lsi.com>,
        DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 9 Aug 2010 19:49:40 +0530
Subject: RE: [PATCH 34/42] drivers/message/fusion: Adjust confusing if
 indentation
Thread-Topic: [PATCH 34/42] drivers/message/fusion: Adjust confusing if
 indentation
Thread-Index: Acs03J59iBOt4FufTseZAMDGnCkKUAC8SmPw
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB24902991CD598@inbmail02.lsi.com>
References: <Pine.LNX.4.64.1008052226570.31692@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1008052226570.31692@ask.diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Julia Lawall [mailto:julia@diku.dk]
> Sent: Friday, August 06, 2010 1:57 AM
> To: Moore, Eric; Support, Software; DL-MPT Fusion Linux; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
> janitors@vger.kernel.org
> Subject: [PATCH 34/42] drivers/message/fusion: Adjust confusing if
> indentation
> 
> From: Julia Lawall <julia@diku.dk>
> 
> Indent the branch of an if.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r disable braces4@
> position p1,p2;
> statement S1,S2;
> @@
> 
> (
> if (...) { ... }
> |
> if (...) S1@p1 S2@p2
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> if (p1[0].column == p2[0].column):
>   cocci.print_main("branch",p1)
>   cocci.print_secs("after",p2)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/message/fusion/mptbase.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c
> b/drivers/message/fusion/mptbase.c
> index d8c668d..92e4b25 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -8049,7 +8049,7 @@ union loginfo_type {
>  			code_desc = ir_code_str[sas_loginfo.dw.code];
>  			if (sas_loginfo.dw.subcode >=
>  			    ARRAY_SIZE(raid_sub_code_str))
> -			break;
> +				break;
Agree. Please consider this patch as an ACKed.
Thanks, Kashyap
>  			if (sas_loginfo.dw.code == 0)
>  				sub_code_desc =
>  				    raid_sub_code_str[sas_loginfo.dw.subcode];
