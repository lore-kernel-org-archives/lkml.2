Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab0HFHfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:35:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43693 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696Ab0HFHfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:35:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=KgOR5bq78Wr0lICu/fCV0Q06GWhmY6ez4E/mIY4ouCymtYZzGoxmkvm5QxaRVHKxL3
         bDiHFzwG+DXyPLzzsDSIf4ynNAv2gbGXEjxLNAFNoDzg8E5YUHv7aV42YsoaxwTfDyMb
         C2pB3H/jpU6RKNSIoUaRb3M5Gmbm9VAX6Yyqc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 2/3] lib: vsprintf: optimised put_dec() for 32-bit machines
Date: Fri, 6 Aug 2010 09:35:26 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, m.nazarewicz@samsung.com,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com> <201008060718.38345.vda.linux@googlemail.com> <87eiec9q1w.fsf@erwin.mina86.com>
In-Reply-To: <87eiec9q1w.fsf@erwin.mina86.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008060935.26989.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 August 2010 09:08, Michal Nazarewicz wrote:
> >> +static noinline_for_stack
> >> +char *put_dec(char *buf, unsigned long long n)
> >> +{
> >> +	uint32_t d3, d2, d1, q;
> >> +
> >> +	if (!n) {
> >> +		*buf++ = '0';
> >> +		return buf;
> >> +	}
> >> +
> >> +	d1  = (n >> 16) & 0xFFFF;
> >> +	d2  = (n >> 32) & 0xFFFF;
> >> +	d3  = (n >> 48) & 0xFFFF;
> >
> > Are you assuming that sizeof(long long) == 8, always?
> 
> Well...  yes.  C requires long long to be at least 64-bit and I don't
> see it being larger in any foreseeable feature.

"640k will be enough for everybody"?

> Wouldn't it be enough to put a static assert here?

I'd prefer the code which works with arbitrarily wide long long.
If needed, use

if (sizeof(long long) == 8)
	64-bit code
else
	generic code

-- 
vda
 
