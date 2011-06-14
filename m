Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1FNOsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:48:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1FNOsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:48:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC v2 02/04] procfs: add hidepid modes as mount options
Date: Tue, 14 Jun 2011 16:48:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        David Rientjes <rientjes@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>
References: <1307889901-6226-1-git-send-email-segoon@openwall.com> <201106141554.50945.arnd@arndb.de> <20110614142429.GB3966@albatros>
In-Reply-To: <20110614142429.GB3966@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106141648.25168.arnd@arndb.de>
X-Provags-ID: V02:K0:RN4krQrjYLDOVlHSgi6by1m3aKW5/sc8joNh9uOy9Qb
 W3t0URx8+7KHsm9azqPMvnIKC2An/n7G3jYn9LBlUp8m+/yzYt
 6biaKRCm17g494znxOODdWNDvVQfr42FPv8ZtQ1SSndKh9dKWt
 ADyCKKt16PxqOJdl1Aadu7RsVCPNb75WD0cjCOPafeQT0Ywyhv
 Mk4APyfhPXvP5iQ1q67Hw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 June 2011, Vasiliy Kulikov wrote:
> > I don't really have an opinion on your patch, but it seems that it does more than
> > the description explains: The hidenet/nohidenet option is in the patch as well,
> > although it doesn't have much of an effect.
> 
> Correct, it is just a matter of a patch division granularity.  Alexey said
> the patch should be divided into pid and net parts.  I divided it into
> (pid + all mount opts parsing) and (actual hidenet usage).  As both pid
> and net parts depend on options parsing, they are not fully independent,
> and cannot be well splitted (or I just don't see how).

Ah, I missed the fact that this is part of a longer series, because I was only Cc:d
on this one patch.

The best way to split it is to just not add the lines regarding the network
stuff in this patch, but to patch them in the other changeset that adds the
code using it. It's slightly more work to create that series though, and it
means that you have to apply the patches in order (which I guess you do anyway).

	Arnd
