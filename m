Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab0E0Q1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:27:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37882 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab0E0Q1v (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 27 May 2010 12:27:51 -0400
Date: Thu, 27 May 2010 12:26:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bastian Blank <waldi@debian.org>, xen-devel@lists.xensource.com,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] Fix name of Xen event-channel device
Message-ID: <20100527162656.GA6190@phenom.dumpdata.com>
References: <20100526105144.GA28280@wavehammer.waldi.eu.org> <20100527073512.GA17135@wavehammer.waldi.eu.org> <20100527143104.GB6040@wavehammer.waldi.eu.org> <20100527150251.GD6040@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527150251.GD6040@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4BFE9D7D.00DA:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 05:02:51PM +0200, Bastian Blank wrote:
> The Xen event-channel device is named evtchn in the kernel but always
> used as /dev/xen/evtchn in userspace. This patch fixes the name.

Hey Bastian,

Is this related to this bug:
http://bugzilla.xensource.com/bugzilla/show_bug.cgi?id=1612 ?

I saw it in some reference to the evtchn but wasn't sure if this is the
same.

> 
> Signed-off-by: Bastian Blank <waldi@debian.org>
> 
> diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
> index 66e185c..89cd743 100644
> --- a/drivers/xen/evtchn.c
> +++ b/drivers/xen/evtchn.c
> @@ -471,7 +471,7 @@ static const struct file_operations evtchn_fops = {
>  
>  static struct miscdevice evtchn_miscdev = {
>  	.minor        = MISC_DYNAMIC_MINOR,
> -	.name         = "evtchn",
> +	.name         = "xen/evtchn",
>  	.fops         = &evtchn_fops,
>  };
>  static int __init evtchn_init(void)
> -- 
> Yes, it is written.  Good shall always destroy evil.
> 		-- Sirah the Yang, "The Omega Glory", stardate unknown
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
