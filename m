Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1CYNML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:12:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1CYNMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:12:09 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=a_0UJ9UWJWAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=H1XzBolG70dieeGWJAAA:9 a=rCUgOqCiP6DwWPt0KIoH_mfRenUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
In-Reply-To: <AANLkTimO3b3D+SofYFLyh8Txk+e4Ke4ToKrBiatdFghr@mail.gmail.com>
References: <20110323153727.GB12003@htj.dyndns.org>
	 <20110324094119.GD12038@htj.dyndns.org>
	 <20110324094151.GE12038@htj.dyndns.org>
	 <20110325033956.GB9313@home.goodmis.org>
	 <AANLkTimO3b3D+SofYFLyh8Txk+e4Ke4ToKrBiatdFghr@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Mar 2011 09:12:07 -0400
Message-ID: <1301058727.14261.174.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 14:13 +0300, Andrey Kuzmin wrote:
> Turning try_lock into indefinitely spinning one breaks its semantics,
> so deadlock is to be expected. But what's wrong in this scenario if
> try_lock spins a bit before giving up? 

Because that will cause this scenario to spin that "little longer"
always, and introduce latencies that did not exist before. Either the
solution does not break this scenario, or it should not go in.

-- Steve


