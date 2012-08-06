Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2HFO0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:26:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45874 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab2HFO0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:26:54 -0400
Date: Mon, 6 Aug 2012 17:26:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/video/mx2_emmaprp.c: use devm_kzalloc and
 devm_clk_get
Message-ID: <20120806142650.GT4403@mwanda>
References: <1344104607-18805-1-git-send-email-Julia.Lawall@lip6.fr>
 <20120806142323.GO4352@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806142323.GO4352@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 05:23:23PM +0300, Dan Carpenter wrote:
> On Sat, Aug 04, 2012 at 08:23:27PM +0200, Julia Lawall wrote:
> > @@ -922,12 +920,7 @@ static int emmaprp_probe(struct platform_device *pdev)
> >  
> >  	platform_set_drvdata(pdev, pcdev);
> >  
> > -	if (devm_request_mem_region(&pdev->dev, res_emma->start,
> > -	    resource_size(res_emma), MEM2MEM_NAME) == NULL)
> > -		goto rel_vdev;
> > -
> > -	pcdev->base_emma = devm_ioremap(&pdev->dev, res_emma->start,
> > -					resource_size(res_emma));
> > +	pcdev->base_emma = devm_request_and_ioremap(&pdev->dev, res_emma);
> >  	if (!pcdev->base_emma)
> >  		goto rel_vdev;
> 
> This was in the original code, but there is a "ret = -ENOMEM;"
> missing here, and again a couple lines down in the original code.
> 

Or should that be -EIO instead of -ENOMEM?  I'm not sure.

regards,
dan carpenter

