Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635Ab0HMS5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 14:57:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33605 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab0HMS5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 14:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SDXMCav0GVChPQftwDNWCDk1cO+1qvjG5IhNKQdSbJUURD84lBbKNXsVEzi2ZHUdz5
         IplNHn9QE3t90oU+G1/XGLrhLSSDAN4cJQjN+gJcWjoG68hcWO6dikK+LRrq1ucr9Vle
         Y9/bR7nX3Wkn9NCsuankRBJKFuDmqaz5j0JMU=
MIME-Version: 1.0
In-Reply-To: <AANLkTin2P5kcrC1SU-ANffSHyW8Ar4x4+qFuqVMFhYJE@mail.gmail.com>
References: <AANLkTimnyXKahtjaFeSsgcq=xMy-pP3na1jidQhZ-dt2@mail.gmail.com>
	<AANLkTin2P5kcrC1SU-ANffSHyW8Ar4x4+qFuqVMFhYJE@mail.gmail.com>
Date: Fri, 13 Aug 2010 11:57:43 -0700
Message-ID: <AANLkTin-dksybH0ANypheovXXubwd+SRCpurdVRU7-Z=@mail.gmail.com>
Subject: Re: Proposal: Use hi-res clock for file timestamps
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 11:45 AM, john stultz <johnstul@us.ibm.com> wrote:
>
> Your stats are off here. The only fast clocksource on x86 is the TSC,
> and its busted on many, many systems. The cpu vendors have only
> recently taken it seriously and resolved the majority of problems
> (however, issues still remain on large numa systems, but its much
> better then the story was 3-7 years ago).

Thank you for the correction.  Still, the number of systems where TSC
works is large, it is growing over time, and....  Really now,
milliseconds?  In 2010?  On some Apple iToy, perhaps...

> On those TSC broken systems that use the hpet or acpi_pm, a
> getnstimeofday call can take 0.5-1.3us, so the penalty can be quite
> severe.

So you are saying my proposal is a bad idea forever?  (But then why
even bother having nanosecond resolution on ext4?)

Or that it is a bad idea for now?

Or that it needs to be refined?  Maybe use hi-res precision on systems
where it is known to be fast?

> And even with the TSC, expect some performance impact, as
> reading hardware and doing the multiply is more costly then just
> fetching a value from memory.

Relative to file system operations?  Seriously?  What performance hit
would you expect on real-world applications?
Something like 0.1% (10 nsec / 10 usec) worst case?

 - Pat
