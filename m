Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab1BYQJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:09:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56915 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab1BYQJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:09:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OWVlM4i3leeNehLmHUukirKeOCfwwjuPLVDSCwyFcwjAkqWQt8B/B+cSwgbww2mdu/
         RdbKiwqPMjn9QLLFvyHiDvYdJQOBFfGIjfEidEeNrPU3hkR0hfxjTVT127ahEmOmB609
         A4qb2xkeNiPMsMVQgHwwuGYg5hS9wINvM3/+I=
Date: Fri, 25 Feb 2011 17:09:03 +0100
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dominik Klein <dk@in-telegence.net>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225160903.GR24828@htj.dyndns.org>
References: <4D66720E.70102@in-telegence.net>
 <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
 <20110225112936.GH24828@htj.dyndns.org>
 <4D679688.7020503@in-telegence.net>
 <20110225131850.GI24828@htj.dyndns.org>
 <20110225145708.GB2994@redhat.com>
 <20110225150329.GM24828@htj.dyndns.org>
 <20110225151113.GD2994@redhat.com>
 <20110225160353.GF2994@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225160353.GF2994@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 25, 2011 at 11:03:53AM -0500, Vivek Goyal wrote:
> +int kthrotld_schedule_delayed_work(struct throtl_data *td,
> +			struct delayed_work *dwork, unsigned long delay)
> +{
> +	return queue_delayed_work(kthrotld_workqueue, dwork, delay);
> +}
> +

I don't think wrapping is necessary.  Defining and using a workqueue
directly should be enough.

> @@ -1113,6 +1120,11 @@ void blk_throtl_exit(struct request_queu
>  
>  static int __init throtl_init(void)
>  {
> +	kthrotld_workqueue = alloc_workqueue("kthrotld",
> +				WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);

And I don't think kthrotld needs to be HIGHPRI.

Thanks.

-- 
tejun
