Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1ESHHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 03:07:31 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34146 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab1ESHHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 03:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=GuNRgSw/llsx+fMIgp0b0tQH5MFL21G03H1nnoDBadp04HyLoX+e2OUw7gvBZ+HyuJ
         APX2WSaA/iI3zUbhoDSq7ntXmn7csinpX0RJ3+e9Fg3P2rmXEe76Nh4vrH8oAA08F+F8
         IB92NA2ATkAUWEHnlAHR5etDEbDoGokKRbih4=
MIME-Version: 1.0
In-Reply-To: <8C5DF277-320D-4DEB-A133-EEC301DE58DC@comsys.rwth-aachen.de>
References: <1305771744-83951-1-git-send-email-tsunanet@gmail.com>
 <20110518.223622.1525088601595365235.davem@davemloft.net> <BANLkTinEN_=jSCw4qR1PqtWaQ+07OMq7tg@mail.gmail.com>
 <20110519.001426.2119532755281545481.davem@davemloft.net> <BANLkTikQEq9+YkJHcTe3PWnRvh7AN=VVWA@mail.gmail.com>
 <9DC9A4D5-8E16-4361-B323-C92D563171A1@comsys.rwth-aachen.de>
 <BANLkTimVMYC5rzizaM+3dReG14obxGL=Bw@mail.gmail.com> <C70B920C-6176-481B-B6D2-E52769291EBC@comsys.rwth-aachen.de>
 <BANLkTiku9KTHCm59cib5KY8mz0ewSLsHFQ@mail.gmail.com> <8C5DF277-320D-4DEB-A133-EEC301DE58DC@comsys.rwth-aachen.de>
From: tsuna <tsunanet@gmail.com>
Date: Thu, 19 May 2011 00:07:09 -0700
Message-ID: <BANLkTimB70u15aGt8BeDNRneZUAMOpfjcQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: Implement a two-level initial RTO as per draft RFC 2988bis-02.
To: Alexander Zimmermann <alexander.zimmermann@comsys.rwth-aachen.de>
Cc: David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, hagen@jauu.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 11:52 PM, Alexander Zimmermann
<alexander.zimmermann@comsys.rwth-aachen.de> wrote:
>> So we're talking about a [200ms ; 120s] range no matter what.
>
> Why is 200ms a valid lower bound for initRTO? I'm aware of
> measurements that 1s is save for Internet, but I don't know of any
> studies that 200ms is save...

The constants that are quoted aren't specific to the initRTO.  They're
used to bound the RTO as it gets adjusted during the TCP session.  See
`tcp_set_rto' in tcp_input.c for reference.

-- 
Benoit "tsuna" Sigoure
Software Engineer @ www.StumbleUpon.com
