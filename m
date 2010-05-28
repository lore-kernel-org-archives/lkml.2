Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab0E1UGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:06:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39133 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab0E1UGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NBS9XyF72dv4D5vsLN7LUtmicdULJs1Tz5ROk7HOVuHdfC1blahuRMYKSz3mAVt15O
         lUZOtZ5RGY+uQSUoNNVEWoknCPjnKkFzhclQwBBvg93b/KswvIwtj42q76uaNmcUiCR0
         L30QxSNWyHzXu7B5XZXaN4uGQmZqDJ0VZhHxY=
Subject: Re: Question about SIOCGIFCONF
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTin5RRIrSwenr1wCuJlEvydVD9_d3U2ZLitSXigs@mail.gmail.com>
References: <AANLkTinUsKL0kqAjRG95xcrqjWPUlNn1TPD21wIJjShS@mail.gmail.com>
	 <1275022651.2446.35.camel@edumazet-laptop>
	 <AANLkTinROjXlrxl_vTAuTyAfj0bqPZiJJpBDa8lkc8IT@mail.gmail.com>
	 <AANLkTin8zU1enOG-SiAaHhdqtNtqW_L1qNGEA9oKFJxz@mail.gmail.com>
	 <AANLkTin5RRIrSwenr1wCuJlEvydVD9_d3U2ZLitSXigs@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 22:06:13 +0200
Message-ID: <1275077173.2472.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 28 mai 2010 à 13:05 -0600, Jeffrey Merkey a écrit :
> The code in question is net-tools/lib/interface.c function
> if_readproc() and associated routines.  Looks like a hole.
> 
> Jeff
> 
> On Fri, May 28, 2010 at 1:02 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
> > Review of the net-tools source code for IFCONFIG indicates that when
> > /proc is not loaded and/or /proc/net/dev is not available, IFCONFIG
> > will attempt to use this ioctl to determine which interfaces are
> > present in the system.  Since the ioctl will not report unbound
> > interfaces which are active, IFCONFIG will not properly report or
> > detect network adapters which are unbound.  This seems to be a hole,
> > although most of the time I assume /proc will always be mounted.
> > Someone should review this and make a decision as to whether or not
> > this could be a problem.  At any rate, it does not work as advertised.
> >

Maybe you could forget about a 20 years old legacy program and use the
real thing : ip

ip link
ip addr
...

Alternatively, you could rewrite ifconfig to use modern API.

(Not depending on /proc , at all)



