Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab1ESQkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:40:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41163 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1ESQka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=L/Tazm/C7GnytJ1fs56vSzAv2dVePrXR7Ohb9RCRhD4yVqVpaMf1fk9M8qoNuN88my
         xP1NewKithUL6wV90KMtKwninN+PF119DsnfbtzYsA9mBkyFbKvP1wvlXqCz+mwVo6VZ
         3/bVWoOoapQdG0/qia55Ao9N4r4pVeVP+0iAs=
MIME-Version: 1.0
In-Reply-To: <ef84de89c2597793d4cca5eee446ba90@localhost>
References: <1305771744-83951-1-git-send-email-tsunanet@gmail.com>
 <20110518.223622.1525088601595365235.davem@davemloft.net> <BANLkTinEN_=jSCw4qR1PqtWaQ+07OMq7tg@mail.gmail.com>
 <20110519.001426.2119532755281545481.davem@davemloft.net> <BANLkTikQEq9+YkJHcTe3PWnRvh7AN=VVWA@mail.gmail.com>
 <9DC9A4D5-8E16-4361-B323-C92D563171A1@comsys.rwth-aachen.de>
 <BANLkTimVMYC5rzizaM+3dReG14obxGL=Bw@mail.gmail.com> <C70B920C-6176-481B-B6D2-E52769291EBC@comsys.rwth-aachen.de>
 <BANLkTiku9KTHCm59cib5KY8mz0ewSLsHFQ@mail.gmail.com> <8C5DF277-320D-4DEB-A133-EEC301DE58DC@comsys.rwth-aachen.de>
 <ef84de89c2597793d4cca5eee446ba90@localhost>
From: tsuna <tsunanet@gmail.com>
Date: Thu, 19 May 2011 09:40:09 -0700
Message-ID: <BANLkTimSZEbnNVzi3UvBFndHp25S0ow7YQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: Implement a two-level initial RTO as per draft RFC 2988bis-02.
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Alexander Zimmermann <alexander.zimmermann@comsys.rwth-aachen.de>,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 1:02 AM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> So yes, it CAN be wise to choose other lower/upper bounds. But keep in
> mind that we should NOT artificial limit ourself. I can image data center
> scenarios where a initial RTO of <1 match perfectly.

Yes that's exactly the point I was trying to make when talking to
Alexander offline.  On today's Internet, RTTs are easily in the
hundreds of ms, and initRTO is 3s, so there's 2 orders of magnitude of
difference.  In my environment, if my RTT is ~2µs, an initRTO of 200ms
means that there's a gap of 6 orders of magnitude (!).  And yes,
although I don't work for High Frequency Trading companies in Wall
Street, I'm already buying switches full of line-rate 10Gb ports with
a port-to-port latency of 500ns for L2/L3 forwarding/switching.  I
expect this kind of network gear will quickly become prevalent in
datacenter/backend environments.

-- 
Benoit "tsuna" Sigoure
Software Engineer @ www.StumbleUpon.com
