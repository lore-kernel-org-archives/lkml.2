Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0CWQqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:46:14 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:58326 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab0CWQqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:46:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HfXWGXaSsaNL2wMfuHMyzSBR4/K4PuucLZ/UcLhJaodGduYHBiq/6+MtaaP2emSTpR
         whIFXnH8E1nvZvaPFRAbhDlJC3PO/pVh3aGaffroTOQk75Rbk5S0XgvjF1SJhhXqug6Y
         gLWs+wWv7FSwoekxhq2OZWFAhusZftmE7h5v8=
Date: Tue, 23 Mar 2010 17:43:23 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Joe Perches <joe@perches.com>, Dan Carpenter <error27@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Srinivasa Deevi <srinivasa.deevi@conexant.com>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] cx231xx: card->driver "Conexant cx231xx Audio" too
 long
Message-ID: <20100323164323.GA2841@joi.lan>
References: <20100319114957.GQ5331@bicker>
 <s5hr5ncxvm9.wl%tiwai@suse.de>
 <20100322153909.GC23411@bicker>
 <1269272627.22616.35.camel@Joe-Laptop.home>
 <s5h39zsxryw.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h39zsxryw.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 05:04:55PM +0100, Takashi Iwai wrote:
> At Mon, 22 Mar 2010 08:43:47 -0700,
> Joe Perches wrote:
> > 
> > On Mon, 2010-03-22 at 18:39 +0300, Dan Carpenter wrote:
> > > card->driver is 15 characters and a NULL, the original code could 
> > > cause a buffer overflow.
> > 
> > > In version 2, I used a better name that Takashi Iwai suggested.
> > 
> > Perhaps it's better to use strncpy as well.
> 
> strlcpy() would be safer :)
> 
> But, in such a case, we want rather that the error is notified at
> build time.
> 
> Maybe a macro like below would be helpful to catch such bugs?
> 
> #define COPY_STRING(buf, src)						\
> 	do {								\
> 		if (__builtin_constant_p(src))				\
> 			BUILD_BUG_ON(strlen(src) >= sizeof(buf));	\
> 		strcpy(buf, src);					\
> 	} while (0)
> 
> and used like:
> 
> struct foo {
> 	char foo[5];
> } x;
> 
> COPY_STRING(x.foo, "OK"); // OK
> COPY_STRING(x.foo, "1234567890"); // NG

why not define strcpy this way?

Marcin
