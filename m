Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050Ab0HMSp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 14:45:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51131 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab0HMSp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 14:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fy6CAhmcP6a3UmKwAZ3Tfj/hTFhFgnoCegOQLT5nLtgs8q1h0rbzjr6ma0OM+u62jR
         B1mTXHlrzyQwefCpok0QWEU0J90FK+K1YEeIr3Ik1pPHgOibj8a3g5thz+eqP8qqeSdA
         8TslVPXCgo9PCWzAarwR7LXa4SGi7ZmjuhEME=
MIME-Version: 1.0
In-Reply-To: <AANLkTimnyXKahtjaFeSsgcq=xMy-pP3na1jidQhZ-dt2@mail.gmail.com>
References: <AANLkTimnyXKahtjaFeSsgcq=xMy-pP3na1jidQhZ-dt2@mail.gmail.com>
Date: Fri, 13 Aug 2010 11:45:54 -0700
X-Google-Sender-Auth: FU-NeeY7ueJiP91xGJmESCuQ2kU
Message-ID: <AANLkTin2P5kcrC1SU-ANffSHyW8Ar4x4+qFuqVMFhYJE@mail.gmail.com>
Subject: Re: Proposal: Use hi-res clock for file timestamps
From: john stultz <johnstul@us.ibm.com>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 11:25 AM, Patrick J. LoPresti
<lopresti@gmail.com> wrote:
> 3) On the 99.99% of Linux systems that are post-1990 x86, it is not
> slow at all, and the performance difference will be utterly
> undetectable in the real world.

Your stats are off here. The only fast clocksource on x86 is the TSC,
and its busted on many, many systems. The cpu vendors have only
recently taken it seriously and resolved the majority of problems
(however, issues still remain on large numa systems, but its much
better then the story was 3-7 years ago).

On those TSC broken systems that use the hpet or acpi_pm, a
getnstimeofday call can take 0.5-1.3us, so the penalty can be quite
severe. And even with the TSC, expect some performance impact, as
reading hardware and doing the multiply is more costly then just
fetching a value from memory.

thanks
-john
