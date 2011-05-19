Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1ESD4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:56:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55404 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab1ESD4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wLZJ9y4qeSKqVUocLXnSN+XygwdzVmF3iUSOPAYtJQ7ODMgjDRZhJ0DcXl81hWoXyK
         6oOrIuKUzJOGxbwDIrv641ciNIXwtCzKlHvU9HtdAAldkMteY58SN04Fc0XGIkAh7kDu
         rBQk4H/w7n47wMN9UtsqcDK2l9JUevNA841iY=
MIME-Version: 1.0
In-Reply-To: <20110518.223622.1525088601595365235.davem@davemloft.net>
References: <20110518.155200.801089483916944725.davem@davemloft.net>
 <1305771744-83951-1-git-send-email-tsunanet@gmail.com> <20110518.223622.1525088601595365235.davem@davemloft.net>
From: tsuna <tsunanet@gmail.com>
Date: Wed, 18 May 2011 20:56:33 -0700
Message-ID: <BANLkTinEN_=jSCw4qR1PqtWaQ+07OMq7tg@mail.gmail.com>
Subject: Re: [PATCH] tcp: Implement a two-level initial RTO as per draft RFC 2988bis-02.
To: David Miller <davem@davemloft.net>
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, hagen@jauu.net,
        eric.dumazet@gmail.com, alexander.zimmermann@comsys.rwth-aachen.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 7:36 PM, David Miller <davem@davemloft.net> wrote:
> From: Benoit Sigoure <tsunanet@gmail.com>
> Date: Wed, 18 May 2011 19:22:24 -0700
>
>> Prior to this patch, Linux would always use 3 seconds (compile-time
>> constant) as the initial RTO.  Draft RFC 2988bis-02 proposes to tune
>> this down to 1 second and, in case of a timeout during the TCP 3WHS,
>> revert the RTO back up to 3 seconds when data transmission begins.
>
> We just had a discussion where it was determined that changes to
> these settings are "network specific" and therefore that if it
> is appropriate at all (I'm still not convinced) it is only suitable
> as a routing metric.

Fair enough.  I'll take another stab at it and see if I can change
this to be on a per network basis.  Do I need any patch that's not yet
in Linus' tree?  I'm referring to this:

On Tue, May 17, 2011 at 5:20 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Adding many knobs to each clone had a huge cost on previous kernels.
> (Think some machines have millions entries in IP route cache), this used
> quite a lot of memory.
>
> With latest David work, we'll consume less ram, because we can now share
> settings, instead of copying them on each dst entry.

If this has already been merged then it sounds like I should have
everything I need..?

-- 
Benoit "tsuna" Sigoure
Software Engineer @ www.StumbleUpon.com
