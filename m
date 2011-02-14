Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1BNMXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:23:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64487 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1BNMXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:23:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=lEIU6CLzqKxhpDXukIqjR49CQZ370NKAkb0Aah7A1uyEdLZ9ctYpgg1oPjsQX/V9IR
         TqyIP0zocVjBhUgCi32M9DPe/qjiqe+YS+EXNGLMMrF1oEUY+yFfq1jChaHkk2xuf/EM
         MaGyK3svEz1q2iV1bgkTLcXCLWyK+A/M1WFlg=
Date: Mon, 14 Feb 2011 15:23:13 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Nicolas de =?iso-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Jesse Gross <jesse@nicira.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] core: dev: don't call BUG() on bad input
Message-ID: <20110214122313.GA10062@albatros>
References: <1297680967-11893-1-git-send-email-segoon@openwall.com>
 <4D591D04.4050000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D591D04.4050000@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Mon, Feb 14, 2011 at 13:16 +0100, Nicolas de Pesloüan wrote:
> >-	BUG_ON(strlen(name)>= sizeof(dev->name));
> >+	if (strnlen(name, sizeof(dev->name))>= sizeof(dev->name)) {

Ehh...  Space after ")" is needed :)

> "size_t strnlen(const char *s, size_t maxlen) : The strnlen()
> function returns strlen(s), if that is less than maxlen, or maxlen
> if there is no '\0' character among the first maxlen characters
> pointed to by s."
> 
> How can strnlen(name, sizeof(dev->name)) be greater than sizeof(dev->name)?
> 
> Shouldn't it be "if (strnlen(name, sizeof(dev->name)) == sizeof(dev->name))" instead?

Not a big deal, but MO it's better to guard from everything that
is not a good input by negating the check.  strnlen() < sizeof() is OK,
strnlen() >= sizeof() is bad.  Is "==" more preferable for net/ coding style?


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
