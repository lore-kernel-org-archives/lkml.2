Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1CKWWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:22:20 -0500
Received: from mail.tpi.com ([70.99.223.143]:2182 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab1CKWWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:22:15 -0500
Message-ID: <4D7AA086.3030500@canonical.com>
Date: Fri, 11 Mar 2011 22:21:58 +0000
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, alan@lxorguk.ukuu.org.uk,
        Roel Kluin <roel.kluin@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [14/17] nfsd: wrong index used in inner loop
References: <20110311204110.753145113@clark.kroah.org>
In-Reply-To: <20110311204110.753145113@clark.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 08:40 PM, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: roel<roel.kluin@gmail.com>
>
> commit 3ec07aa9522e3d5e9d5ede7bef946756e623a0a0 upstream.
>
> Index i was already used in the outer loop
>
> Signed-off-by: Roel Kluin<roel.kluin@gmail.com>
> Signed-off-by: J. Bruce Fields<bfields@redhat.com>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>
> ---
>   fs/nfsd/nfs4xdr.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -1114,7 +1114,7 @@ nfsd4_decode_create_session(struct nfsd4
>
>   	u32 dummy;
>   	char *machine_name;
> -	int i;
> +	int i, j;
>   	int nr_secflavs;
>
>   	READ_BUF(16);
> @@ -1187,7 +1187,7 @@ nfsd4_decode_create_session(struct nfsd4
>   			READ_BUF(4);
>   			READ32(dummy);
>   			READ_BUF(dummy * 4);
> -			for (i = 0; i<  dummy; ++i)
> +			for (j = 0; j<  dummy; ++j)
>   				READ32(dummy);
>   			break;
>   		case RPC_AUTH_GSS:
>
>
> --

I agree that fixing the index in this loop is a good thing, but its 
caused me to look at the result:

for (j = 0; j<  dummy; ++j)
	READ32(dummy);

It seems to me that this loop might never terminate if the original 
buffer is maliciously constructed, e.g., 0, 1, 2, 3, ... Is the data in 
this buffer really that well vetted?

rtg
-- 
Tim Gardner tim.gardner@canonical.com
