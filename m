Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1ARJ0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 04:26:41 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40425 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1ARJ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 04:26:40 -0500
Subject: Re: [PATCH 3/3] trusted-keys: small cleanup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: safford@watson.ibm.com, safford@us.ibm.com, jj@chaosbits.net,
        dhowells@redhat.com, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <201101180139.p0I1dh9T066040@www262.sakura.ne.jp>
References: <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net>
	 <1295011682.7804.2.camel@localhost.localdomain>
	 <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp>
	 <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp>
	 <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net>
	 <201101170039.p0H0d1f5085735@www262.sakura.ne.jp>
	 <201101170041.p0H0ffFE086481@www262.sakura.ne.jp>
	 <201101170044.p0H0iLQW087457@www262.sakura.ne.jp>
	 <1295298400.2642.9.camel@localhost.localdomain>
	 <201101180139.p0I1dh9T066040@www262.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 04:26:33 -0500
Message-ID: <1295342793.3426.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 10:39 +0900, Tetsuo Handa wrote:
> Mimi Zohar wrote:
> > Change the existing '(!ret)' to '(ret < 0)', like the rest of the code?
> > It's not wrong, but ....
> 
> Something like this?

Actually, I was only asking for a one line change in the patch.

> >       va_end(argp);
> > -     ret = crypto_shash_final(&sdesc->shash, paramdigest);
> > +     if (!ret)
> > +             ret = crypto_shash_final(&sdesc->shash, paramdigest);
> >       if (!ret)

Change the second '(!ret)' here, the crypto_shash_file() return code
test, from '(!ret)' to '(ret < 0)', like the other crypto_shash_file()
tests.

Thanks!

Mimi

