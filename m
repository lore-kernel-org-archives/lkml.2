Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1FJKUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:20:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37720 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1FJKUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=IDEThQ74kdg1tayURXdjU2lOzRMnNiF0X5ltlZEpjJ2oF+7rf/IlGynfUr664GSAHQ
         i58MPpOzt9ZsSxBzSgF20AyDshRclqVKLDDwtaiLmdBtBgLbPMC/n3yCMjO23ZSfPoC0
         0zfRAetJaRxCMCyG8CvNjhdpE9ABcsl7ry3Ak=
MIME-Version: 1.0
In-Reply-To: <21324.1307677721@jrobl>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
 <20110608153208.dc705cda.akpm@linux-foundation.org> <20110609115934.3c53f78f@notabene.brown>
 <20110608205233.ebfedc4d.akpm@linux-foundation.org> <87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
 <20110609123843.77153b27.akpm@linux-foundation.org> <877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu>
 <21324.1307677721@jrobl>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Fri, 10 Jun 2011 12:19:43 +0200
X-Google-Sender-Auth: RBh3j4uQJyLWsEE3WbUlvknis5M
Message-ID: <BANLkTi=Vu4t+FFKGapJZVjQ_e1rGD7ug2g@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2011 05:48, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:

> Michal Suchanek:
>> No implementation will satisfy all needs. There is always some
>> compromise between availability (userspace/in-tree/easy to patch in)
>> feature completeness (eg. AuFS is not so easy to forward-port to new
>> kernels but has numerous features) performance, reliability.
>
> Not so easy?
> While I stopped updating aufs2 just before 2.6.39 (because I simply have
> no time), I think it is easy for aufs to support 2.6.39 or 3.0.
> Would you tell me what is so difficult?
>
To be fair any out-of-tree in-kernel solution is going to be equally
hard to forward-port.

I am not a kernel VFS hacker so whenever there is a Linux VFS change
other than trivial changes like swapping headers and renaming stuff I
can't use an out-of-tree patch with the changed VFS.

Any solution that leverages the in-kernel interfaces, either hacking
them directly or calling functions not available from userspace is
going to have this issue unless merged into the kernel.

For me the current unionnount and overlayfs are sufficient in that I
can run a live filesystem on top of them reliably.

Others use overlayfs for small systems (eg. OpenWRT) where a solution
as large as aufs is likely not going to fit unless most features can
be compiled out.

Anyway, as I understand it aufs is not going to be merged because the
VFS maintainers don't want a filesyetem (like aufs) but do accept only
mount (overlayfs or unionmount).

So overlayfs is the only way forward now since unionmount development
has stopped.

Thanks

Michal
