Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab0L0VGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:06:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63973 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab0L0VGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:06:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=nn1vkDanrJD9IXJLPqlL1KglowS6+KsP80aRTRPdMPwDDPDZu96dzI1NHgSpRV8Ctf
         Q4AhvfsbuzXqrchsyOu8E67prGHG6u5ciAUadO4q7GTIjNkOPxEKpWMStSdhYOsm7HQI
         Cb1tL+JUkhTpYhJf8tN7qcRH9IGKfnpjs31RI=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH] perf-probe: no need to initialize the entire temporary buffers in synthesize_perf_probe_point()
References: <m3wrn07blu.fsf@gmail.com> <4D142591.2030101@hitachi.com>
	<20101224131441.GA3128@ghostprotocols.net>
Date: Mon, 27 Dec 2010 22:06:35 +0100
In-Reply-To: <20101224131441.GA3128@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Fri, 24 Dec 2010 11:14:41 -0200")
Message-ID: <m3pqsnvsbo.fsf@gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme@ghostprotocols.net> writes:

> Em Fri, Dec 24, 2010 at 01:46:09PM +0900, Masami Hiramatsu escreveu:
>> (2010/12/24 0:27), Franck Bui-Huu wrote:
>> > This patches only put a single null byte at the beginning of each
>> > temporary buffers line[], offs[], file[] instead of filling their
>> > full contents with null bytes.
>
>> Hmm, sorry but NAK it.
>
>> IMHO, with modern chips, the original code has no problem from the
>> viewpoint of memory access (all are cached and no need to access just
>> one byte) nor a bottleneck.
>> I'd rather use '= ""' style initialization for local variables from the
>> viewpoint of readability.
>
> No strong feelings here, not really a fast path, just learned something
> new, I thought that that kind of initialization would be equivalent to
> what Franck proposed, but gcc really uses the most efficient way of
> zeroing the whole string (movq for things like that, and rep stos for
> bigger arrays, etc).
> 

gcc has no other choice than clearing the whole buffers here since it's
how C initialisation works.

Thanks
-- 
		Franck
