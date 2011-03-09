Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab1CIPSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:18:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64300 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab1CIPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:18:07 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=VOOo5lHdzEUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=-O8ovmbt_oh7YEivNtwA:9 a=pWvKQMcyC1QZHdXk0DwA:7 a=uEij4YNSPPj0OOPSFPVAuCSCFVIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 04/15] ftrace: pack event structures.
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, dhsharp@google.com
In-Reply-To: <20110308.223951.193722389.davem@davemloft.net>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <1291421609-14665-5-git-send-email-dhsharp@google.com>
	 <1299627003.20306.94.camel@gandalf.stny.rr.com>
	 <20110308.223951.193722389.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 10:18:04 -0500
Message-ID: <1299683884.15854.154.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 22:39 -0800, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Tue, 08 Mar 2011 18:30:03 -0500
> 
> > I'm going back through this patch set and looking to incorporate it into
> > 2.6.39. But I know how touchy sparc is with "packed" data structures. Do
> > you see this patch as hurting sparc?
> > 
> > I wonder if we should change this to something like:
> > 
> > #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> > # define do_event_packed __attirbute__((packed))
> > #else
> > # define do_event_packed
> > #endif
> > 
> > and use "do_event_packed" instead?
> 
> I think you should elide packed at all costs, and instead tell the compiler
> what your intentions are by exposing the real types using unions or
> similar instead of hiding it in an opaque way behind final char[] arrays.

The problem here is not the issue of char[] but because of the way
ftrace's header was 12 bytes and caused everything that had a 8byte word
use another 4 bytes to align it. As I stated in another email, I think
removing the "int lock_depth" from the ftrace header should solve this.

David (Sharp), the reason for the "packed" was because of that extra 4
bytes in the ftrace header, right? So removing the lock_depth should fix
the issues that you've seen?

-- Steve



