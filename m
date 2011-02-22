Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab1BVMj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:39:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38534 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1BVMj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:39:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=oHxMMqR/kAHiq/BA7bez8Ju5bQwiIS7F5KPutYEl5JC7IU4Qv2FveTMW3X+SWjTBMH
         9RJUk4cJUhHPpiZQhGbz0cVCf6itjdq8G45dpLGWU2VHJS92ZPXX8+cohiROYh3+OtGP
         hZGVFLF20vVy6z1RDXXWHBQRdrJmexgXz0aBI=
Date: Tue, 22 Feb 2011 15:36:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dirk Eibach <eibach@gdsys.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Fix wrong pointer type in pca953x
Message-ID: <20110222123601.GA1966@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dirk Eibach <eibach@gdsys.de>, linux-kernel@vger.kernel.org
References: <1298365010-22951-1-git-send-email-eibach@gdsys.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298365010-22951-1-git-send-email-eibach@gdsys.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:56:50AM +0100, Dirk Eibach wrote:
>  	struct pca953x_platform_data *pdata;
>  	struct device_node *node;
> -	const uint16_t *val;
> +	const u32 *val;
>  

This should probably be signed?  We compare it against zero later on.

                if (*val < 0)
                        dev_warn(&client->dev,
                                 "invalid gpio-base in device tree\n");

regards,
dan carpenter
