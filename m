Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0GLQU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:20:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33891 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0GLQUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:20:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VrheAjALyCwqgDQdrJd5c9oMHkdBWuyOVM6OOh8Ihhubh1KZt8HnMda9YmP8LJIDM/
         UCczR2A79MD2nr0dr59SVgSwm3GtSpaf2RMoCECQoPTLdbUcv4zJedBuE7m87xAK0aqi
         ueK3hh17+wlMls1XV+OQK/AeIOyXcheZjKZvo=
Date: Mon, 12 Jul 2010 18:19:16 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
        Tejun Heo <tj@kernel.org>, Stoyan Gaydarov <sgayda2@uiuc.edu>,
        =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: line6: fix leaks in line6_probe()
Message-ID: <20100712161916.GB5658@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
	Tejun Heo <tj@kernel.org>, Stoyan Gaydarov <sgayda2@uiuc.edu>,
	=?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1278946051-30118-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278946051-30118-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 06:47:30PM +0400, Kulikov Vasiliy wrote:
> -	if (ret < 0) {
> -		line6_destruct(interface);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto err_put;

This should be:
		goto err_destruct;

regards,
dan carpenter

>  
>  	dev_info(&interface->dev, "Line6 %s now attached\n",
>  		 line6->properties->name);
>  	line6_devices[devnum] = line6;
>  	line6_list_devices();
> +	return 0;
> +
> +err_destruct:
> +	line6_destruct(interface);
> +err_put:
> +	usb_put_intf(interface);
> +	usb_put_dev(usbdev);
>  	return ret;
>  }
>  

