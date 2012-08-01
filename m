Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2HAD2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 23:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab2HAD1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 23:27:52 -0400
Date: Wed, 1 Aug 2012 00:19:30 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [RFC PATCH] KVM: Only print vcpu_unimpl when DEBUG is set
Message-ID: <20120801031930.GB31711@amt.cnet>
References: <20120726122248.GA252@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726122248.GA252@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 02:22:48PM +0200, Markus Trippelsdorf wrote:
> Every time I start qemu-kvm on my system the following line is added to
> the syslog:
> 
>  vcpu0 unhandled rdmsr: 0xc0010001
> 
> AFAICS all calls to vcpu_unimpl only contain debugging info with little
> or no value for the end user.
> 
> Wouldn't something like the following patch make sense?
> 
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

It could be useful for debugging (but then lots of other things could).

Anyone has a use for this?

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b70b48b..6bd816f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -321,7 +321,7 @@ struct kvm {
>  #define kvm_debug(fmt, ...) \
>  	pr_debug("kvm [%i]: " fmt, task_pid_nr(current), ## __VA_ARGS__)
>  #define kvm_pr_unimpl(fmt, ...) \
> -	pr_err_ratelimited("kvm [%i]: " fmt, \
> +	pr_debug_ratelimited("kvm [%i]: " fmt, \
>  			   task_tgid_nr(current), ## __VA_ARGS__)
>  
>  /* The guest did something we don't support. */
> 
> -- 
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
