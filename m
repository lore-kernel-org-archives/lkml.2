Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1EaOa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:30:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33625 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab1EaOaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:30:24 -0400
Date: Tue, 31 May 2011 10:28:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Jaya Kumar <jayalk@intworks.biz>, Paul Mundt <lethal@linux-sh.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Jiri Kosina <trivial@kernel.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [TRIVIAL PATCH V2 next 12/15] video: Convert vmalloc/memset to
 vzalloc
Message-ID: <20110531142833.GJ14641@dumpdata.com>
References: <cover.1306603968.git.joe@perches.com>
 <77538de911b8af99f68b7bcfbaaedce8e40db04f.1306603968.git.joe@perches.com>
 <201105281948.12941.heiko@sntech.de>
 <1306606413.20336.9.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306606413.20336.9.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DE4FB24.00FB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 11:13:33AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> on the:

> diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
> index a20218c..beac52f 100644
> --- a/drivers/video/xen-fbfront.c
> +++ b/drivers/video/xen-fbfront.c
> @@ -395,10 +395,9 @@ static int __devinit xenfb_probe(struct xenbus_device *dev,
>  	spin_lock_init(&info->dirty_lock);
>  	spin_lock_init(&info->resize_lock);
>  
> -	info->fb = vmalloc(fb_size);
> +	info->fb = vzalloc(fb_size);
>  	if (info->fb == NULL)
>  		goto error_nomem;
> -	memset(info->fb, 0, fb_size);
>  
>  	info->nr_pages = (fb_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
