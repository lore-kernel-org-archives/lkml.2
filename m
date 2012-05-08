Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2EHBXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 21:23:49 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47379 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755991Ab2EHBXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 21:23:48 -0400
X-Sasl-enc: QwpID9qbQy154KlUsxrE74FU+hj5GCVRJjHUzA6GrfoZ 1336440227
Date: Mon, 7 May 2012 22:23:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuahkhan@gmail.com>, mingo@redhat.com, tglx@linutronix.de,
        tigran@aivazian.fsnet.co.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86: kernel/microcode_core.c simple_strtoul
 cleanup
Message-ID: <20120508012341.GA27000@khazad-dum.debian.net>
References: <1336324264.2897.9.camel@lorien2>
 <20120507104943.GA3896@x1.osrc.amd.com>
 <4FA815E3.1030101@zytor.com>
 <20120507211612.GA19700@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507211612.GA19700@liondog.tnic>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2012, Borislav Petkov wrote:
> On Mon, May 07, 2012 at 11:35:15AM -0700, H. Peter Anvin wrote:
> > I'll pick it up.  I presume I have your ack on it?
> 
> Yep, sure.
> 
> Btw, while at it, I gave the whole sysfs reload thing a critical look
> and whether it is at all that useful - this thing gives you microcode
> reloading on a single CPU. And what you actually wanna do is reload the
> microcode on the whole system, i.e. all cores in succession.
> 
> And we don't use the reload thing on AMD, so I was wondering, if you
> guys don't find it useful on Intel hw, maybe we can remove it completely
> in favor of
> 
> $ rmmod microcode; modprobe microcode
> 
> which reloads the ucode on each core.
> 
> Of course, one can iterate over each core in a shell-loop and write into
> the reload file to reload ucode after having updated the ucode image in
> /lib/firmware but removing and then modprobing the module is shorter :-)

Can we PLEASE fix it properly by adding a new node (which is _not_ per-cpu)
that requests the microcode core to refresh all cpus?  Preferably by
invalidating the microcode cache, THEN fetching each required microcode just
once for the first core that needs it, and caching it for use the other
cores.  You can leave the (IMHO mostly useless) per-cpu sysfs nodes alone,
so as to not break ABI, or deprecate them for an year or something.

I am speaking this with my userland maintainer hat.  I *do NOT* want to
rmmod crap in a production server to update microcode.  And I want to be
able to support static-compiled microcode.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
