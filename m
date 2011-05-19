Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1ESG0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 02:26:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55280 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab1ESG0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 02:26:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DZ900ToyCeLLk1WXxVjX+iwfXzY2oOKmGxAqD55VhkSXQbWMPccXN7J6pbfduJUNHO
         m85zn6wqee+O/+2p541mdztKhK2+5syuZFWcg/N/SYjos9Pd3H6HOv79RJV3SKhZHY/m
         wIjU8m6ZPUDP6eY5zU/1P+YWBqxLtB7JFBUn4=
MIME-Version: 1.0
In-Reply-To: <9DC9A4D5-8E16-4361-B323-C92D563171A1@comsys.rwth-aachen.de>
References: <1305771744-83951-1-git-send-email-tsunanet@gmail.com>
 <20110518.223622.1525088601595365235.davem@davemloft.net> <BANLkTinEN_=jSCw4qR1PqtWaQ+07OMq7tg@mail.gmail.com>
 <20110519.001426.2119532755281545481.davem@davemloft.net> <BANLkTikQEq9+YkJHcTe3PWnRvh7AN=VVWA@mail.gmail.com>
 <9DC9A4D5-8E16-4361-B323-C92D563171A1@comsys.rwth-aachen.de>
From: tsuna <tsunanet@gmail.com>
Date: Wed, 18 May 2011 23:25:58 -0700
Message-ID: <BANLkTimVMYC5rzizaM+3dReG14obxGL=Bw@mail.gmail.com>
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

On Wed, May 18, 2011 at 11:10 PM, Alexander Zimmermann
<alexander.zimmermann@comsys.rwth-aachen.de> wrote:
> Am 19.05.2011 um 06:33 schrieb tsuna:
>> Presumably if the user decides to tweak these knobs, they'll know
>> what's appropriate for their environment.
>
> Are you sure? I'm not. I fully agree with David that minRTO is

s/minRTO/initRTO/, right?

> something that a user shout not control at all

I personally don't like to hold the hand and spoon feed users too
much, I want to trust them to be responsible and know what they're
doing.  Yes, there will always be people who will act stupid and do
stupid things with whatever knobs you expose.  The web is full of
people who advise to tune up all the TCP rmem/wmem parameters to crazy
high level based on the voodoo belief that they're going to improve
their TCP performance, but then as long as you have knobs in your
system, these people will misuse them anyway and shoot themselves in
the foot, what can we do about that.

There's also a good chunk of people who know what they're doing, and
for them compile-time constants are annoying because it's inconvenient
to experiment and iterate quickly when you need to recompile your
kernel to change a value.  If turning the compile time constant into a
knob leaves the code reasonably straightforward and doesn't incur too
much overhead, then why not do it?

Regarding this knob in particular, I can imagine that people who are
in environment where RTT easily gets around 1s will be upset by the
change in the default value, and doubly upset that they have to
recompile their kernel to change the value back to 3s.  I'm in favor
of the reduction of initRTO, for the same reason Google is, but I can
also understand that the direction we're taking might not be
appropriate for everyone.

-- 
Benoit "tsuna" Sigoure
Software Engineer @ www.StumbleUpon.com
