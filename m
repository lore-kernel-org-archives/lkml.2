Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1KSHIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 02:08:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37002 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab1KSHIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 02:08:37 -0500
MIME-Version: 1.0
In-Reply-To: <20111118232729.GA3902@gerrit.erg.abdn.ac.uk>
References: <CABPbr_msepemFt4ezGVRk3QS0MU3F47MKimfV4Y+6jqvUrLFeA@mail.gmail.com>
	<20111118120430.GG3317@hell>
	<CABPbr_=fgB-AKK3H8ryccqA7SUO=ejZiWP7tEKYLh=qNG5r7CQ@mail.gmail.com>
	<20111118232729.GA3902@gerrit.erg.abdn.ac.uk>
Date: Sat, 19 Nov 2011 15:08:35 +0800
Message-ID: <CABPbr_kB3mRZWoVcRVN3rmqtNmQqXq-G6P9fwE=3GDN9B_OGVw@mail.gmail.com>
Subject: Re: ipv4 udplite broken in >=linux-3.0 ?
From: Jinxin Zheng <jinxinzheng@gmail.com>
To: Gerrit Renker <gerrit@erg.abdn.ac.uk>, Hagen Paul Pfeifer <hagen@jauu.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 7:27 AM, Gerrit Renker <gerrit@erg.abdn.ac.uk> wrote:
> Jinxin, -
> | On Fri, Nov 18, 2011 at 8:04 PM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> | > * Jinxin Zheng | 2011-11-18 12:09:25 [+0800]:
> | >
> | >>I don't know how to debug udplite. Can any one of you give me a tip on
> | >>how to get more debug info, then I can do further test and provide
> | >>with it?
> | >
> | > net-next works for me:
> That is very likely the point. Between 2.6.39 and 3.0 UDP-Lite checksum coverage was
> broken and got only recently fixed. The correct kernel version should have the
> commit shown below. Alternatively, you can check include/net/udplite.h, which
> should mention "Slow-path" and "Fast-Path" computation. UDP-Litev6 still uses the
> slow path, that is why it is not affected.
>
>
> commit f36c23bb9f822904dacf83a329518d0a5fde7968
> Author: Gerrit Renker <gerrit@erg.abdn.ac.uk>
> Date:   Mon Oct 17 19:07:30 2011 -0400
>
>    udplite: fast-path computation of checksum coverage
>
>    Commit 903ab86d195cca295379699299c5fc10beba31c7 of 1 March this year ("udp: Add
>    lockless transmit path") introduced a new fast TX path that broke the checksum
>    coverage computation of UDP-lite, which so far depended on up->len (only set
>    if the socket is locked and 0 in the fast path).
>
>    Fixed by providing both fast- and slow-path computation of checksum coverage.
>    The latter can be removed when UDP(-lite)v6 also uses a lockless transmit path.
>
>

Thanks, Gerrit. Upgrading to the upstream linux-3.2-rc2 fixed the problem :)

-- 
Zheng Jinxin
