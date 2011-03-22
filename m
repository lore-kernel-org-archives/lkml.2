Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1CVNeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:34:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab1CVNeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:34:12 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=w6ZHtbzEN-4A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=G3MgQ9XIAAAA:8 a=DZbqwH4ksJXkRW4qaFcA:9 a=w1E88A5RFzMlPn5_uXwA:7 a=gCaFlZj-XcHtoyQgt7r02k9jQPgA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 22 Mar 2011 09:34:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Brian Downing <bdowning@lavos.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [bisect] kernel 2.6.38 regression with root nfs mounting
Message-ID: <20110322133409.GN14675@home.goodmis.org>
References: <AANLkTimjmdi8sFTTjSPerOVgHQ+pjjwwMvCUX3AJ16At@mail.gmail.com>
 <AANLkTimxrdhhukoVP76c4PUzeWsKOEy-_bHOgCCFabxc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimxrdhhukoVP76c4PUzeWsKOEy-_bHOgCCFabxc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:52:12AM +0100, Belisko Marek wrote:
> CC: also lkml

And please Cc those that are on that commit.


> 
> After update from 2.6.38-rc8 to 2.6.38 is mounting rootfs over nfs not possible.
> Log:
> VFS: Mounted root (nfs filesystem) on device 0:14.
> Freeing init memory: 132K
> nfs: server 10.146.1.21 not responding, still trying
> nfs: server 10.146.1.21 not responding, still trying
> 
> This is never ending. I make short bisect (not too much commits
> between versions)
> and bad commit was reported: 53d4737580535e073963b91ce87d4216e434fab5
> 
> NFS: NFSROOT should default to "proto=udp"
> 
> I've tested on mini2440 board (DM9000, static IP).
> Is there some missing option or something else to be checked?

Sometimes git bisect messes up. Did you verify that commit broke the
kernel? It's easy to do:

git checkout 53d4737580535e073963b91ce87d4216e434fab5~1

then build and boot the kernel and test if it works.

git checkout 53d4737580535e073963b91ce87d4216e434fab5

then build and boot again and test if it fails.

If the first checkout works and the second fails, then you have verified
that is the guilty commit.

Thanks,

-- Steve

> 
> Regards,
> 
> marek
> 
> --
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
> 
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> icq: 290551086
> web: http://open-nandra.com
