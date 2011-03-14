Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1CNMrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:47:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39597 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab1CNMrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:47:35 -0400
Subject: Re: [PATCH] SUNRPC: svc_register error overwritten in next iteration
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <4D7B74C7.7060506@gmail.com>
Date: Mon, 14 Mar 2011 08:47:18 -0400
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F864C699-63D9-46EB-998F-A783038A7356@oracle.com>
References: <4D7B74C7.7060506@gmail.com>
To: roel <roel.kluin@gmail.com>
X-Mailer: Apple Mail (2.1082)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D7E0E59.012B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 12, 2011, at 8:27 AM, roel wrote:

> The break is in the inner loop, the svc_register() error is overwritten
> in the next iteration. Only the error in the last iteration is returned.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> net/sunrpc/svc.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
> 
> Is this needed?

Maybe.  Did you encounter a problem here?

> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index 08e05a8..5fd08c0 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -889,6 +889,8 @@ int svc_register(const struct svc_serv *serv, const int family,
> 			if (error < 0)
> 				break;
> 		}
> +		if (error < 0)
> +			break;
> 	}
> 
> 	return error;

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com




