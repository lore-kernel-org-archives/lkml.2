Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab0LYQww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 11:52:52 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40181 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab0LYQwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 11:52:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=t3MGK5rynbHfpxeFp/mAyWzZ0HtVoelbyRq5oeFge15H/wXsjqpKvpjPoRnOH7sXpz
         zsEp89omw5yeA1sw5dc6cR3hDvJJYpZA9CuZVHi2wfIMJSs8u6UUdzBAqvQRQJd3vjwf
         Bn4pLlC3/b3z25UgUt7D0yRUouoLW7YxJzyW4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1012242251090.23107@router.home>
References: <20101214174847.887713690@linux.com>
	<20101214174900.058235985@linux.com>
	<4D0CC982.3030905@kernel.org>
	<alpine.DEB.2.00.1012211634560.3769@router.home>
	<4D11373D.9010205@zytor.com>
	<20101222091358.GC27861@htj.dyndns.org>
	<alpine.DEB.2.00.1012231812280.22549@router.home>
	<4D13E7D5.7020503@zytor.com>
	<alpine.DEB.2.00.1012242251090.23107@router.home>
Date: Sat, 25 Dec 2010 17:52:50 +0100
X-Google-Sender-Auth: XXTEId5qBaIdoCr8LkRYiMMwdps
Message-ID: <AANLkTikSwwMtDwx4wGM8hO4riZFVmtkq_bihVvPirO8F@mail.gmail.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for this_cpu_cmpxchg_double
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 5:53 AM, Christoph Lameter <cl@linux.com> wrote:
> Oh gosh. So we would be using a tight corner case for gcc that may only
> work with certain versions of gcc? Note that the current version does only
> return a boolean. There is no need for returning double words. I'd be
> happy if we could *pass* double words.

I wouldn't call it a corner case.  It's pretty clearly defined in the
ABI.  But that said, it might still be problematic on other
architectures when we try to apply it to different architectures.  Is
everyone against just taking a scalar for the first variable instead
of taking a pointer?  I'd be happier with that than the current one.

Thanks.

-- 
tejun
