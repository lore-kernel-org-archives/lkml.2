Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab1ANNp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:45:26 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55989 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1ANNpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:45:19 -0500
To: safford@watson.ibm.com
Cc: dhowells@redhat.com, safford@us.ibm.com, jmorris@namei.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Trusted and Encrypted Keys: fix up TSS_rawhmac() so wealways kfree() and remember to call va_end()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
	<1295011682.7804.2.camel@localhost.localdomain>
In-Reply-To: <1295011682.7804.2.camel@localhost.localdomain>
Message-Id: <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 14 Jan 2011 22:45:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Safford wrote:
> On Thu, 2011-01-13 at 21:07 +0100, Jesper Juhl wrote:
> > In security/keys/trusted_defined.c::TSS_rawhmac() we may leak the storage 
> > allocated to 'sdesc' if
> >   data = va_arg(argp, unsigned char *);
> > results in a NULL 'data' and we then leave the function by returning 
> > -EINVAL. We also neglect calling va_end(argp) in that case and furthermore 
> > we neglect va_end(argp) if
> >   ret = crypto_shash_update(&sdesc->shash, data, dlen);
> > results in ret being negative and we then jump to the 'out' label.
> > 
> > I believe this patch takes care of these issues. Please review and 
> > consider for inclusion.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> thanks for catching this.
> 
> Acked-by: David Safford <safford@watson.ibm.com>

Please wait. That patch is incorrect. I'm making patch now.
