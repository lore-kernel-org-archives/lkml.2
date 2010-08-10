Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab0HJQHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:07:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38201 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab0HJQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Y2Romed4nQnlGTjNLE006PdG1UiQY3sAWizgWB+jsGAVKtLKckj9ZjmC8sDcBXB+Wp
         sfAhnFtXwnY5NkF6679y7baTAgv0mTt74Zlyk2K1B1bFeFUhHAIlw7YYQ6Fi5+PNhnPT
         9XjL5KzMZc39SMdU0DQ17V1ZpQCXgztM0j3gw=
Date: Tue, 10 Aug 2010 13:06:53 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Chris Metcalf <cmetcalf@tilera.com>,
        David Miller <davem@davemloft.net>, willy@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf build broke by list_head changes...
Message-ID: <20100810160653.GB21829@ghostprotocols.net>
References: <20100809.235746.115919762.davem@davemloft.net>
 <20100810124445.GA14843@merkur.ravnborg.org>
 <20100810134600.GF18824@ghostprotocols.net>
 <201008101629.53768.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008101629.53768.arnd@arndb.de>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 10, 2010 at 04:29:53PM +0200, Arnd Bergmann escreveu:
> On Tuesday 10 August 2010, Arnaldo Carvalho de Melo wrote:
> > It started just keeping private copies, I guess it should get back to
> > that since the reaction to this kind of same source repo code sharing
> > was, well, not good :-)
> > 
> > Alternatives?
> 
> If perf wants to play tricks with the header files, we should probably
> make them explicit, as in this ugly bit of code.

Nah, no more ifdefs, the goal was more to share things with tools
developed/shipped in the kernel source repository, not to do something
just for perf.
 
> diff --git a/include/linux/types.h b/include/linux/types.h
> @@ -178,7 +178,7 @@ typedef __u64 __bitwise __be64;
>  typedef __u16 __bitwise __sum16;
>  typedef __u32 __bitwise __wsum;
>  
> -#ifdef __KERNEL__
> +#if defined(__KERNEL__) || defined(__PERF__)
>  typedef unsigned __bitwise__ gfp_t;

- Arnaldo
