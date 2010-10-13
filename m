Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0JMWpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 18:45:55 -0400
Received: from nm9.bullet.mail.ac4.yahoo.com ([98.139.52.206]:22114 "HELO
	nm9.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751523Ab0JMWpy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 18:45:54 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2010 18:45:54 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 370881.84550.bm@omp1014.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=H4hLfbSCgODpDCBoUuLsxtAfNSlm85EtJZC1k/qnWDcByFP/kP5GCP++xpYWrLGI/cTDYMlHZK1auo7cPjDp8oNKVEYeQPdmQA5sUTO85WJF4jvNxqdj5e7pba07BxIa42L04VgYxZ/HMN44WqvSodaOAya9HeM5z6k9UmOnGWI=;
Message-ID: <243672.50367.qm@web50106.mail.re2.yahoo.com>
X-YMail-OSG: wRXlM_kVM1mj6GYO2feZVFkXTPNQRhS0baJZpUxPPyLPVV7
 ANGs8Hkt.
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.106.282862
Date: Wed, 13 Oct 2010 15:39:33 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH -next] edac/mce_amd: fix shift warning
To: lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        akpm <akpm@linux-foundation.org>
In-Reply-To: <20101013131057.88238be6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 10/13/10, Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> Subject: [PATCH -next] edac/mce_amd: fix shift warning
> To: "lkml" <linux-kernel@vger.kernel.org>
> Cc: "Doug Thompson" <dougthompson@xmission.com>, "Borislav Petkov" <borislav.petkov@amd.com>, "akpm" <akpm@linux-foundation.org>
> Date: Wednesday, October 13, 2010, 2:10 PM
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> The BIT() macro works on unsigned longs, but this warning
> happens
> on i386 (X86_32), where UL is 32 bits and this value needs
> to be
> 64 bits, so use open-coded ULL.

good find


> 
> drivers/edac/mce_amd.c:262: warning: left shift count >=
> width of type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>


> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  drivers/edac/mce_amd.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-next-20101012.orig/drivers/edac/mce_amd.c
> +++ linux-next-20101012/drivers/edac/mce_amd.c
> @@ -259,7 +259,8 @@ static void amd_decode_ic_mce(struct
> mce
>          pr_cont("%s TLB
> %s.\n", LL_MSG(ec),
>             
> (xec ? "multimatch" : "parity error"));
>      else if (BUS_ERROR(ec)) {
> -        bool k8 =
> (boot_cpu_data.x86 == 0xf && (m->status &
> BIT(58)));
> +        bool k8 =
> (boot_cpu_data.x86 == 0xf &&
> +           
>     (m->status & (1ULL <<
> 58)));
>  
>          pr_cont("during
> %s.\n", (k8 ? "system linefill" : "NB data read"));
>      } else if (fam_ops->ic_mce(ec))
> 
