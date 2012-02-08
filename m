Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2BHDXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 22:23:40 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:29727
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755332Ab2BHDXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 22:23:25 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F31EA7D.2010706@am.sony.com>
Date: Tue, 7 Feb 2012 19:22:37 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Greg KH <gregkh@suse.de>, linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/5] logger: Change logger_offset() from macro to function
References: <4F31DC31.6040303@am.sony.com>
In-Reply-To: <4F31DC31.6040303@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/12 18:21, Tim Bird wrote:
> Convert to function and add log as a parameter, rather than relying
> on log in the context of the macro.
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> ---
>  drivers/staging/android/logger.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index ffc2d04..92456d7 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -60,7 +60,11 @@ struct logger_reader {
>  };
> 
>  /* logger_offset - returns index 'n' into the log via (optimized) modulus */
> -#define logger_offset(n)	((n) & (log->size - 1))
> +size_t logger_offset(struct logger_log *log, size_t n)
> +{
> +	return n & (log->size-1);

        return n & (log->size - 1);
> +}
> +

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>

