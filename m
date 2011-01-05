Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1AEXas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:30:48 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49899 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1AEXar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:30:47 -0500
Message-ID: <4D24FF22.9010803@linux.vnet.ibm.com>
Date: Wed, 05 Jan 2011 15:30:42 -0800
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "M. Mohan Kumar" <mohan@in.ibm.com>
CC: v9fs-developer <v9fs-developer@lists.sourceforge.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [PATCH] net/9p: Use proper data types
References: <1294246423-8454-1-git-send-email-mohan@in.ibm.com>
In-Reply-To: <1294246423-8454-1-git-send-email-mohan@in.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/5/2011 8:53 AM, M. Mohan Kumar wrote:
> Use proper data types for storing the count of the binary blob and
> length of a string. Without this patch length calculation of string will
> always result in -1 because of comparision between signed and unsigned
> integer.
> 
> Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
> ---
>  net/9p/protocol.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/9p/protocol.c b/net/9p/protocol.c
> index c5180fd..2902eb1 100644
> --- a/net/9p/protocol.c
> +++ b/net/9p/protocol.c
> @@ -234,14 +234,14 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
>  			}
>  			break;
>  		case 'D':{
> -				int32_t *count = va_arg(ap, int32_t *);
> +				uint32_t *count = va_arg(ap, int32_t *);

uinit32_t * inside the va_arg also to be consistent?
>  				void **data = va_arg(ap, void **);
> 
>  				errcode =
>  				    p9pdu_readf(pdu, proto_version, "d", count);
>  				if (!errcode) {
>  					*count =
> -					    min_t(int32_t, *count,
> +					    min_t(uint32_t, *count,
>  						  pdu->size - pdu->offset);
>  					*data = &pdu->sdata[pdu->offset];
>  				}

Did you take care of MAX/max_t comparisons too? Looks like you missed at least
one for case 's'

Thanks,
JV


> @@ -404,9 +404,9 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
>  			break;
>  		case 's':{
>  				const char *sptr = va_arg(ap, const char *);
> -				int16_t len = 0;
> +				uint16_t len = 0;
>  				if (sptr)
> -					len = min_t(int16_t, strlen(sptr),
> +					len = min_t(uint16_t, strlen(sptr),
>  								USHRT_MAX);
> 
>  				errcode = p9pdu_writef(pdu, proto_version,


