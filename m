Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1LFU72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:59:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1LFU71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:59:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ming Lei <ming.lei@canonical.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face detection
Date: Tue, 06 Dec 2011 21:59:11 +0100
Message-ID: <2893768.IFJoMOGMWT@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <CACVXFVOoQRZKDEWUtuq3hE3H25b7UUWWAJbsTGgVHJcUbnihig@mail.gmail.com>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com> <CACVXFVO8Uk808J9HgVv6ernd4x_QwN3YsAaERF=W8F=NQrLwQw@mail.gmail.com> <CACVXFVOoQRZKDEWUtuq3hE3H25b7UUWWAJbsTGgVHJcUbnihig@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6knwqCJcJwzvPyybYK7+xXGMYcgvcSZPuSNlU/FTly1
 fUxmbTijEtuJGgvxcs8k0whcgPtQpNymHOl8JyFKExTtm1DVQg
 Jr8sLOlBk3sOFNEbQXgqjDQdsBFMKnW+j/ir1gEdk/qo/Zutvw
 zCT8X0s1eX3KCZ9CwF3b7i7xsvj22vRkEC7TgMZ+w7It1sSJNw
 vMEqhhMDYrw/4OUdJPHrWX4aayeCiJC6ofsYQDQm+4JKu4sZXw
 eURlYbgvn/vYxgnjrfB1HWZGiOpnD07RMMGlT8lliHJ7fq+Bi9
 XYrTWGb/Hw/5dzjec8ukWJxZhN4bQdKgm5Dk5C0jYfbY4H1j5R
 hEBL1rmssqVukCCDWPTU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 December 2011 23:45:27 Ming Lei wrote:
> >
> > and it is not difficult to implement it in a generic way so that new
> > array parameters can be supported as 64/32 compatible.
> 
> How about the below patch to support 64/32 compatible array parameter?

Looks technically correct to me, if you replace the 'return -ENOMEM' with
'ret = -ENOMEM;\n goto out;'.

The video_usercopy function already has multiple micro-optimizations
(on-stack buffers, cmd_input_size) that make it more complex than
I'd hope, but your addition seems ok to me.

Let's see what Mauro thinks.

	Arnd
