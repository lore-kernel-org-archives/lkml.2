Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab0IXTh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:37:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54983 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab0IXTh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PR6qEYNu6TQiLDuCNFoZ4vdta2JInE57E+qHgu0oWvO5rNATJoRlD95dWgCc/wolTo
         nCSLf6Xm3OAU5Iw538+AZWsfUzPL8nT9RJA8RYpwjhhV5oMgtQQlnYRrT/SHQj50Ee7s
         wFhGzpw+6GWNZmDEacGw65qFmygJk8gfPbM8k=
Date: Fri, 24 Sep 2010 23:37:51 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
        dilinger@queued.net
Subject: Re: [PATCH] olpc_battery: Fix endian neutral breakage for s16
 values
Message-ID: <20100924193751.GA16745@oksana.dev.rtsoft.ru>
References: <20100924193133.E5C7A9D401B@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100924193133.E5C7A9D401B@zog.reactivated.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 08:31:33PM +0100, Daniel Drake wrote:
> From: Richard A. Smith <richard@laptop.org>
> 
> When the driver was updated to be endian neutral (8e9c7716c)
> the signed part of the s16 values was lost.  This is because be16_to_cpu()
> returns a signed value.  This patch casts the values back to a s16 number
> prior to the the cast up to an int.
> 
> Signed-off-by: Richard A. Smith <richard@laptop.org>
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Good catch.

[...]
> -		val->intval = (int)be16_to_cpu(ec_word) * 9760L / 32;
> +		val->intval = (int)((s16)be16_to_cpu(ec_word)) * 9760L / 32;

Do we really need "(int)" then?

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
