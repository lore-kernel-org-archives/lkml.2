Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0FMWTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 18:19:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:31007 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0FMWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 18:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=k8fuKy+3Wk9C80s3e9uOrCZeCG/TeOPSnWiJifk0pHxhHtDemdl885NaERdvwJ1a98
         OPLYeM4EQXIs2xbBSPgHT5I0+/nV2qNAYfH1TqtK5FR48wyjJZfEQlxfou9L1PPhUh4z
         5S0OrlpySnlm3oQdWfak0ZX2ugGTAHdOi80cU=
Date: Mon, 14 Jun 2010 00:18:03 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>,
       Stuart Bennett <stuart@freedesktop.org>,
       Marcin =?utf-8?Q?Ko=C5=9Bcielnicki?= <koriakin@0x04.net>,
       Shinpei KATO <shinpei@il.is.s.u-tokyo.ac.jp>,
       nouveau@lists.freedesktop.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHv2] kmmio/mmiotrace: fix double free of kmmio_fault_pages
Message-ID: <20100613221803.GB3829@joi.lan>
References: <20100613215654.GA3829@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100613215654.GA3829@joi.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 11:56:54PM +0200, Marcin Slusarz wrote:
> After every iounmap mmiotrace has to free kmmio_fault_pages, but it
> can't do it directly, so it defers freeing by RCU.
> 
> It usually works, but when mmiotraced code calls ioremap-iounmap
> multiple times without sleeping between (so RCU won't kick in and
> start freeing) it can be given the same virtual address, so at
> every iounmap mmiotrace will schedule the same pages for release.
> Obviously it will explode on second free.
> 
> Fix it by marking kmmio_fault_pages which are scheduled for release
> and not adding them second time.
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Acked-by: Pekka Paalanen <pq@iki.fi>
> Cc: Stuart Bennett <stuart@freedesktop.org>
> Tested-by: Marcin Kościelnicki <koriakin@0x04.net>
> Tested-by: Shinpei KATO <shinpei@il.is.s.u-tokyo.ac.jp>
> ---

It would be good to apply it to -stable too. Sometimes people has to test
some earlier kernels because of unfixable constraints (you know, these
uncooperative vendors not releasing their binary drivers for latest kernels)

Marcin
