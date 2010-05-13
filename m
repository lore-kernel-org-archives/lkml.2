Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab0EMQBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:01:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37865 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759244Ab0EMQBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:01:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fc5eDQI4FUyovGdYpyR7ZaNpguUkg3+00IKV5VVbggCEnPbMCmfCnqs49uIx1B0Nj3
         UdYY3isZgRbYcImJypENKrVaZpMla5wbasdSTCo0Gymk19EWgj+ALhlUYRWZnPL58NJr
         RDzw/RyliQM/os+UFHWqJrKRRLIEcXGbTejRA=
MIME-Version: 1.0
In-Reply-To: <20100513145826.GJ30926@ghostprotocols.net>
References: <AANLkTins2yCK-rvmdaaSQoBum4haHLhPx34EeJDg21Gg@mail.gmail.com>
	 <20100513145826.GJ30926@ghostprotocols.net>
Date: Thu, 13 May 2010 18:01:10 +0200
X-Google-Sender-Auth: q7lWlfolNzjuQ7bKJiuNeq0DM2c
Message-ID: <AANLkTin1w6OoS_6qzMqIizBxOGiV7DXJ936-hdHSFCD8@mail.gmail.com>
Subject: Re: perf: relative path to source for perf probe?
From: Chase Douglas <chase.douglas@canonical.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 4:58 PM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Look in tools/perf/util/symbol.c, these variables are the ones tools use
> to govern how the symbol system work wrt finding vmlinux:
>
> symbol_conf.use_vmlinux_path
> symbol_conf.vmlinux_name
>
> In addition to this it will use what is in ~/.debug/ if it has a
> build-id in the perf.data header.
>
> The changes for support kvm also touched this and allow for some
> prefixing to look for guest symbols, generalizing that to make guest
> kernel vmlinux + modules relative location be reused to look for
> relative location for host kernel vmlinux + modules seems the way to go.

After reading this some more, I think we are talking about two
different things. I think your notes above are referring to locating
the vmlinux image and other debug symbols. This seems to work fine for
me using the -k flag. However, I'm encountering an issue where the
source code location isn't found. I think this is fairly specific to
the probe command of perf, which is fairly new, so maybe it's missing
the same level of support that the symbol finding code has?

Thanks,

-- Chase
