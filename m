Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab1FVRsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:48:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49292 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab1FVRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DtdG8mAOHiaifrj6eOZK+9QiPKnb4y2a0u4Zc25gr7QVYuC4RcxJeSu68noHhiJ9A5
         oCtfC4EXN6XHgyZ/3BiE8NMu4h8T5LMjnV9ma2O0RsTNYtm1PUtt4NDBzU+ovOuWmpMt
         pqy+kRVTfUS6949j4Rr4Snh5iYW6fhVE5v1P0=
Date: Wed, 22 Jun 2011 21:48:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110622174812.GA13392@albatros>
References: <20110622095341.GA3353@albatros>
 <1308760683.10423.16.camel@Joe-Laptop>
 <20110622165355.GB11803@albatros>
 <1308762841.10423.28.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308762841.10423.28.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 10:14 -0700, Joe Perches wrote:
> On Wed, 2011-06-22 at 20:53 +0400, Vasiliy Kulikov wrote:
> > On Wed, Jun 22, 2011 at 09:38 -0700, Joe Perches wrote:
> > > > +	if ((c >= ' ' && c < 127) || c == '\n')
> > > 	if (isprint(c))
> > #define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) != 0)
> > It slightly differs from what I've written.  It (1) lacks '\n',
> 
> You still need tab,

Correct.

> so:
> 
> if (isprint(c) || isspace(c))

No, it also allows vertical tabs.  Looking into __ctype only ' ', '\n' and
'\t' should be allowed among all _S, so

if (isprint(c) || (c == '\n') || (c == '\t'))


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
