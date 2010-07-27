Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0G0X64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:58:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45507 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0G0X6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:58:52 -0400
Message-ID: <4C4F7277.8050306@zytor.com>
Date: Tue, 27 Jul 2010 16:57:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: xchg() and cmpxchg()
References: <20100701175144.GA2116@kroah.com>	<20100701173218.125822294@clark.site>	<20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<AANLkTim_xKrPSTNqS3JWipjlAkmeDnlEYcHt1cn90ggB@mail.gmail.com>	<4C3CAAC6.501@redhat.com> <AANLkTik_hRn9acIuuRBJDWLuQVUh9qE-blvgFmUQvzlz@mail.gmail.com> <4C4F1B6D.1070207@goop.org>
In-Reply-To: <4C4F1B6D.1070207@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I've stared at this issue for most of the day, and I have a fix
for the immediate issue.

However, I also am convinced that the whole scheme with the __xg() macro
is just broken.  It was introduced in 1.3.11 when xchg and cmpxchg where
neither "asm volatile" nor had "memory" clobbers as an apparent way to
keep gcc from moving memory references around it, but since the array
type is "unsigned long" rather than a char type, it probably doesn't
even work right, and with asm volatile/memory clobber it should not be
necessary.

At this point I'd like to push an urgent patch to fix the immediate
issue, and a cleanup patch getting rid of __xg() for .36.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

