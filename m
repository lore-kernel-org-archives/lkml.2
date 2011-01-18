Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1ARLDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 06:03:53 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:49863 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab1ARLDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 06:03:52 -0500
To: zohar@linux.vnet.ibm.com
Cc: safford@watson.ibm.com, safford@us.ibm.com, jj@chaosbits.net,
        dhowells@redhat.com, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] trusted-keys: small cleanup
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201101170041.p0H0ffFE086481@www262.sakura.ne.jp>
	<201101170044.p0H0iLQW087457@www262.sakura.ne.jp>
	<1295298400.2642.9.camel@localhost.localdomain>
	<201101180139.p0I1dh9T066040@www262.sakura.ne.jp>
	<1295342793.3426.12.camel@localhost.localdomain>
In-Reply-To: <1295342793.3426.12.camel@localhost.localdomain>
Message-Id: <201101182003.ACH57348.HOtFMVOLJQSOFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 18 Jan 2011 20:03:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar wrote:
> > >       va_end(argp);
> > > -     ret = crypto_shash_final(&sdesc->shash, paramdigest);
> > > +     if (!ret)
> > > +             ret = crypto_shash_final(&sdesc->shash, paramdigest);
> > >       if (!ret)
> 
> Change the second '(!ret)' here, the crypto_shash_file() return code
> test, from '(!ret)' to '(ret < 0)', like the other crypto_shash_file()
> tests.

Did you mean changing from

	if (!ret)
		ret = crypto_shash_final(&sdesc->shash, paramdigest);

to

	if (ret < 0)
		ret = crypto_shash_final(&sdesc->shash, paramdigest);

(i.e. invert the condition)?

I'm confused. Would you make the patch by yourself?
