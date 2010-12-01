Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab0LAU2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:28:48 -0500
Received: from tomasu.net ([64.85.170.234]:56293 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab0LAU2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:28:47 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Pekka Pietikainen <pp@ee.oulu.fi>
Subject: Re: low overhead packet capturing on linux
Date: Wed, 1 Dec 2010 13:28:32 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: LKML <linux-kernel@vger.kernel.org>
References: <201011301728.05197.thomas@fjellstrom.ca> <20101201121957.GA3747@ee.oulu.fi>
In-Reply-To: <20101201121957.GA3747@ee.oulu.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012011328.32937.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 1, 2010, Pekka Pietikainen wrote:
> On Tue, Nov 30, 2010 at 05:28:05PM -0700, Thomas Fjellstrom wrote:
> > I'm working on a little tool to monitor and measure bandwidth use on a vm
> > host, down to keeping track of all guest and host bandwidth, including,
> > eventually per layer7 protocol use.
> > 
> > Right now I have a pretty simple setup, I setup an AF_PACKET socket,
> > select on it, and read data as it comes in. Obviously, this has a fatal
> > flaw. It takes up a rather large amount of cpu time just to capture the
> > packets. On a GbE interface, it uses up easily 60-80% cpu (on a 2.6Ghz
> > amd phenom II cpu core) just to capture the packets, trying to do
> > anything fancy with them will likely cause the kernel to drop some
> > packets.
> > 
> > So what I'm looking for is a very low overhead way to capture packets.
> > I've come up with a few ideas, some of which I have no idea if they'd
> > even work.
> 
> Have you checked out
> 
> http://public.lanl.gov/cpw/ (IIRC it's actually a part of recent libpcap,
> but could be wrong) and http://www.ntop.org/PF_RING.html ?

Hi,

Thanks, yes, at least I've seen the cpw page, probably briefly looked at the 
PF_RING stuff before. But I'll take a closer look this time, thanks :)

When I was looking before, I was unduly rejecting things that required 
patching the kernel, or adding special drivers. But if it really can help I 
might as well take a look.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
