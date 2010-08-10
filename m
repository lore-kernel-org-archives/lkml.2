Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0HJKqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 06:46:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49140 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0HJKql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 06:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ze25s1fM+ZPh1F3VIXa2wu2nu+S0eMfkodvr4tuPGf5q7HeiF98pV3GBqS4XY3UDKb
         TEut+tP6kAr2+6pcbT46bci8c1vQvFl3Q8D8juJzGTnepgCZUj6n/SWzOaB+cnwFV48I
         2aBMuCglJwi1G/8YtgtPcv08WE/ZrnGub+vCg=
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100810070555.GA16638@elte.hu>
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
	 <87k4o08fv9.fsf@basil.nowhere.org> <1281336031.976.11.camel@leonhard>
	 <20100809064441.GC29524@basil.fritz.box> <1281337485.976.24.camel@leonhard>
	 <20100809072226.GD29524@basil.fritz.box> <4C604F54.2080506@zytor.com>
	 <20100810070555.GA16638@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 19:46:31 +0900
Message-ID: <1281437191.1670.33.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-10 (화), 09:05 +0200, Ingo Molnar:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > We pass -fno-strict-overflow to the kernel now, which takes care of the
> > underlying problem, at least for current versions of gcc.  Unfortunately
> > we still have people who want to use very old gcc versions to compile
> > the kernel, so it's probably better to leave it in at least until we
> > formally kill off support for gcc 3.
> 
> Namhyung, mind sending a patch that adds a comment to __pa_symbol() to point 
> out the connection to -fno-strict-overflow and that it can be removed once all 
> supported versions of GCC understand -fno-strict-overflow?
> 
> That would make for one less piece of legacy voodoo code in the kernel ;-)
> 
> Thanks,
> 
> 	Ingo

No problem. :-) But before that, let me clarify this: It seems
-fno-strict-overflow is all about the signed arithmetic and
__pa_symbol() does unsigned one. Is it really matters here?


-- 
Regards,
Namhyung Kim


