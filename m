Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab1IGVnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:43:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab1IGVng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:43:36 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Wed, 7 Sep 2011 17:43:16 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.35.14-96.fc14.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <1315429827.3576.61.camel@lappy> <4E67E396.702@redhat.com>
In-Reply-To: <4E67E396.702@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109071743.16811.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 07, 2011 05:35:18 PM Jarod Wilson wrote:
> Another proposal that has been kicked around: a 3rd random chardev, 
> which implements this functionality, leaving urandom unscathed. Some 
> udev magic or a driver param could move/disable/whatever urandom and put 
> this alternate device in its place. Ultimately, identical behavior, but 
> the true urandom doesn't get altered at all.

Right, and that's what I was trying to say is that if we do all that and switch out 
urandom with something new that does what we need, what's the difference in just 
patching the behavior into urandom and calling it a day? Its simpler, less fragile, 
admins won't make mistakes setting up the wrong one in a chroot, already has the 
FIPS-140 dressing, and is auditable.

-Steve
