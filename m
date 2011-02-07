Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1BGGbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 01:31:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65100 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1BGGbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 01:31:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=MnNm7uljXsbsESnClZiOzA3QeaAi24r03QE1Zyivzeq6N2N+WVHpIe9pczFscRvg4D
         G5oGdGTL5JqpXrNmjDSvp5tsUNG+pzMUGng2FYU+NxirGgDfGML6Vj7nLVILDEwcrY7x
         jCmt0WgYb8A1j8NhEKy/tBJTrTW05EuWyaAi8=
Date: Mon, 7 Feb 2011 09:30:47 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, jon.nettleton@gmail.com,
        cjb@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] olpc_dcon: move more variables into dcon_priv
Message-ID: <20110207063047.GC4384@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andres Salomon <dilinger@queued.net>, gregkh@suse.de,
	devel@driverdev.osuosl.org, jon.nettleton@gmail.com, cjb@laptop.org,
	linux-kernel@vger.kernel.org
References: <20110206152846.68f14482@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110206152846.68f14482@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 03:28:46PM -0800, Andres Salomon wrote:
>  	bool mono:1;
> +	bool asleep:1;
                   ^^ 

Not needed.

> -	return sprintf(buf, "%d\n", dcon_sleep_val);
> +	struct dcon_priv *dcon = dev_get_drvdata(dev);
> +	return sprintf(buf, "%d\n", dcon->asleep ? 1 : 0);
                                                 ^^^^^^^

Also not needed.

These are fussy things.  Feel free to fix them in a later patch series.

regards,
dan carpenter

