Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1HSTVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:21:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19475 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab1HSTVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:21:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Gj76Z+tjeXyEBmTvdQNNNBZZ8TEch2odyvH+YTte7xe6F+cZmo4Dd+NpW/jOPPCY0
	FGgl0N+ViaGplMsOxbl7Q==
Date: Fri, 19 Aug 2011 12:21:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Pavel Ivanov <paivanof@gmail.com>, Mahmood Naderan <nt_mahmood@yahoo.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        "\"linux-mm@kvack.org\"" <linux-mm@kvack.org>
Subject: Re: running of out memory => kernel crash
In-Reply-To: <201108190025.27444.vda.linux@googlemail.com>
Message-ID: <alpine.DEB.2.00.1108191219400.20477@chino.kir.corp.google.com>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <CAK1hOcM5u-zB7fUnR5QVJGBrEnLMhK9Q+EmWBknThga70UQaLw@mail.gmail.com> <CAG1a4rus+VVhhB3ayuDF2pCQDusLekGOAxf33+u_uzxC1yz1MA@mail.gmail.com> <201108190025.27444.vda.linux@googlemail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011, Denys Vlasenko wrote:

> Exactly. Server has no means to know when the situation is
> bad enough to start killing. IIRC now the rule is simple:
> OOM killing starts only when allocations fail.
> 
> Perhaps it is possible to add "start OOM killing if less than N free
> pages are available", but this will be complex, and won't be good enough
> for some configs with many zones (thus, will require even more complications).
> 

Allocations start to fail, and oom killings then start to occur, only when 
the set of allowed zones fall below their minimum watermarks which usually 
includes several hundred kilobytes or several megabytes of free memory for 
lowmem situations.
