Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab2LTRs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:48:56 -0500
Received: from nm33-vm7.bullet.mail.bf1.yahoo.com ([72.30.239.207]:25658 "EHLO
	nm33-vm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947Ab2LTRst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:48:49 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 12:48:49 EST
X-Yahoo-Newman-Id: 737512.58557.bm@smtp216.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tE5RPg4VM1mni29Dc6L.T0I9bNqhjQQRpCAVDkleb6bUNHW
 HvWK9bPCVr.hSqlf1d3dS09rpBNLcHfCBksJlx3AiVHr6Su_HNB6t6qrFK8S
 2.01EJSK0n7iv5z9biM5ArU8axtTDJm6_.L12_2bGVcxTWbDMHrWZ3H.nB7_
 eSf4ZRYbn35R0sr4uay0xDplHqFQlNpcCrhTZYeYZ9oD0v7Fc9rjotP2JQBQ
 micCc6amXkQNLZb2.nyFoTf8cspMBMkiKajAbZUwvuQdmA8xiE0.kvqjiWZD
 ya.RvRHiOD2bvH.SSSWq8nW0OnZeWsCuS4F4bnjNHlcnwajj4O_ysDmPtfmp
 HgevFuVWhPoOKMugvXTlshlEfugIc.yqXn6z97gU5mRffTDQ24U0tXXOuXML
 OBEYDOmIFougI9ny0XklICANIkwzG46e4bbskI_yg.Y2Zq85YguLnL9P.yl8
 lM7TKAfSmQEFK1Fp5jEDNN3A0fWZJn.Rjo3mM5mlxboPAeEyl72SGIyjD_Si
 a.0SAZ54bRmeHzkd63BVkg.SAoCcfnLNhkK5uJVSjQB8-
X-Yahoo-SMTP: L_RQyf6swBBuWeM._x5NHQ4bag--
Message-ID: <50D34DFF.1060503@yahoo.com>
Date: Thu, 20 Dec 2012 10:42:23 -0700
From: doug thompson <norsk5@yahoo.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Jean Delvare <jdelvare@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>
Subject: Re: [PATCH 141/241] i7300_edac: Fix error flag testing
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com> <1355407206-17100-142-git-send-email-herton.krzesinski@canonical.com>
In-Reply-To: <1355407206-17100-142-git-send-email-herton.krzesinski@canonical.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by:  Doug Thompson <dougthompson@xmission.com>


On 12/13/2012 06:58 AM, Herton Ronaldo Krzesinski wrote:
> 3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Jean Delvare <jdelvare@suse.de>
>
> commit 7e06b7a3333f5c7a0cec12aff20d39c5c87c0795 upstream.
>
> * Right-shift the values in GET_FBD_FAT_IDX and GET_FBD_NF_IDX, so
>   that the callers get the result they expect.
> * Fix definition of FERR_FAT_FBD_ERR_MASK.
> * Call GET_FBD_NF_IDX, not GET_FBD_FAT_IDX, when operating on
>   register FERR_NF_FBD. We were lucky they have the same definition.
>
> This fixes kernel bug #44131:
> https://bugzilla.kernel.org/show_bug.cgi?id=44131
>
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Doug Thompson <dougthompson@xmission.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> ---
>  drivers/edac/i7300_edac.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
> index 97c22fd..856a250 100644
> --- a/drivers/edac/i7300_edac.c
> +++ b/drivers/edac/i7300_edac.c
> @@ -215,8 +215,8 @@ static const char *ferr_fat_fbd_name[] = {
>  	[0]  = "Memory Write error on non-redundant retry or "
>  	       "FBD configuration Write error on retry",
>  };
> -#define GET_FBD_FAT_IDX(fbderr)	(fbderr & (3 << 28))
> -#define FERR_FAT_FBD_ERR_MASK ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 3))
> +#define GET_FBD_FAT_IDX(fbderr)	(((fbderr) >> 28) & 3)
> +#define FERR_FAT_FBD_ERR_MASK ((1 << 0) | (1 << 1) | (1 << 2) | (1 << 22))
>  
>  #define FERR_NF_FBD	0xa0
>  static const char *ferr_nf_fbd_name[] = {
> @@ -243,7 +243,7 @@ static const char *ferr_nf_fbd_name[] = {
>  	[1]  = "Aliased Uncorrectable Non-Mirrored Demand Data ECC",
>  	[0]  = "Uncorrectable Data ECC on Replay",
>  };
> -#define GET_FBD_NF_IDX(fbderr)	(fbderr & (3 << 28))
> +#define GET_FBD_NF_IDX(fbderr)	(((fbderr) >> 28) & 3)
>  #define FERR_NF_FBD_ERR_MASK ((1 << 24) | (1 << 23) | (1 << 22) | (1 << 21) |\
>  			      (1 << 18) | (1 << 17) | (1 << 16) | (1 << 15) |\
>  			      (1 << 14) | (1 << 13) | (1 << 11) | (1 << 10) |\
> @@ -482,7 +482,7 @@ static void i7300_process_fbd_error(struct mem_ctl_info *mci)
>  		errnum = find_first_bit(&errors,
>  					ARRAY_SIZE(ferr_nf_fbd_name));
>  		specific = GET_ERR_FROM_TABLE(ferr_nf_fbd_name, errnum);
> -		branch = (GET_FBD_FAT_IDX(error_reg) == 2) ? 1 : 0;
> +		branch = (GET_FBD_NF_IDX(error_reg) == 2) ? 1 : 0;
>  
>  		pci_read_config_dword(pvt->pci_dev_16_1_fsb_addr_map,
>  			REDMEMA, &syndrome);

