Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0HNP2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 11:28:41 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63234 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0HNP2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 11:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=nS2f+OWH7jjkU5MVhHftok7Nvur7TkAiosVxYRAeC9HeDCHebI2oZHiTX2QUNje1wz
         KOITozTtWM0n/G2FAZeQ7u/aH/nfpFB/yDd7RfpS/VVYsjTnqXLh7LNfaN/y8ZwC6i8Z
         6E1dEaBk5V54WKhkRadPbWRZsPqESTgjL+/RQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20100814134343.GD17430@suse.de>
References: <AANLkTi=YL_VKKDU8ok=OYotPhyQcGsVB2O-PU29+70YT@mail.gmail.com>
	<AANLkTikP3FHZ0f7umRRzXcT1ytfa9XfE41UHmQ98kO2h@mail.gmail.com>
	<20100814134343.GD17430@suse.de>
Date: Sat, 14 Aug 2010 17:28:39 +0200
Message-ID: <AANLkTi=qDBpN-6Ro833nHXY5P5OcvFbBrjYW9A4ewREP@mail.gmail.com>
Subject: Re: Call traces w/ 2.6.35.2 (not w/ 2.6.35.1 plus 2.6.35.2-rc1)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, wylda@volny.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 3:43 PM, Greg KH <gregkh@suse.de> wrote:
> On Sat, Aug 14, 2010 at 08:36:30AM +0200, Sedat Dilek wrote:
>> Hope this helps to give an overview what has changed:
[...]
>
> I still fail to understand what you are trying to show here at all.
>
> confused,
>
> greg k-h
>

I was trying to show you that the patches in .35.2-rc1 and .35.2 are
not the same.
Normally, the rcX patches become the final ones.

Unfortunately, I was too lazy to check the names of the patches and
simply compared the files that have been modified (lines beginning
with "diff --git a/file b/file").

In the meantime, Mr./Mrs.(?) "wylda" (sorry, don't know if first or
last name) bisected the problem [1].

The confusing part for me is why "fresh" upstream patches entered a
2.6.35.y fix-series.
I can't say if only i386 is concerned, but as

mm: fix missing page table unmap for stack guard page failure case
mm: keep a guard page below a grow-down stack segment

are also upstream patches, I think the both cause problems for
.35-gitX also [2].

- Sedat -

[1] https://bugzilla.kernel.org/show_bug.cgi?id=16588
[2] https://bugzilla.kernel.org/show_bug.cgi?id=16588#c5
[3] [1] http://lkml.org/lkml/2010/8/14/54
