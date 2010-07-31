Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0GaTJc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 15:09:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47793 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0GaTJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 15:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=fKrlHhZpHTyHHbxwqD5zQUuawZlWlw+oBqx9sxD+Y3FZXQlyQgXNy5Rw9WHX7ImSmm
         J/eq30B8z+jc4g4JE0S2e9Rn97I/GSyQFPcqnXvdyLdDoGPPxJuyWOwX5RBy8SzGxAou
         Ymb6kOciW2gA8kstKOoVewb0VQJNNzD8pnHaQ=
Date: Sat, 31 Jul 2010 21:09:08 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>, Christoph Egger <siccegge@cs.fau.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] 68328serial: check return value of copy_*_user()
	instead of access_ok()
Message-ID: <20100731190907.GE26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Ungerer <gerg@uclinux.org>,
	Christoph Egger <siccegge@cs.fau.de>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org
References: <1280597881-8365-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280597881-8365-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 09:38:00PM +0400, Kulikov Vasiliy wrote:
> -						sizeof(struct m68k_serial)))
> -				return -EFAULT;
> -			copy_to_user((struct m68k_serial *) arg,
> +			return copy_to_user((struct m68k_serial *) arg,
>  				    info, sizeof(struct m68k_serial));

We should return if -EFAULT copy_to_user() failes here.

> -			return 0;
> -			
>  		default:
>  			return -ENOIOCTLCMD;
>  		}

Smatch would have caught that but I don't have a cross compile
environment set up.

regards,
dan carpenter
