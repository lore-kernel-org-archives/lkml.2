Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab0KAMVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:21:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41155 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab0KAMVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ic4Y7JEKExLXAO0NvSdUSqFUqakeUA9VpWnvKhBa7Yjhy+msF7l4EYUcrhSqZPdlTi
         XBt9qEvkvxYZHGgAdZMUjrDKGzgX0Rc6i4o3eH2RNi52BJYx51DaJ3Bn7kVoUkAB0j8I
         TPZLo6cPT2DNIXEPDbzLWdJ2ATDKpFmUXJBQ0=
Date: Mon, 1 Nov 2010 20:26:33 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@us.ibm.com>,
        Karim Yaghmour <karim@opersys.com>, Paul Mundt <lethal@linux-sh.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
 vzalloc rather than vmalloc and memset
Message-ID: <20101101122633.GN6023@cr0.nay.redhat.com>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net>
 <20101030214704.GA20005@Krystal>
 <alpine.LNX.2.00.1010302343590.1572@swampdragon.chaosbits.net>
 <20101031183913.GA26160@Krystal>
 <20101031174635.88f441fe.akpm@linux-foundation.org>
 <20101101112754.GA12762@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101101112754.GA12762@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 07:27:55AM -0400, Mathieu Desnoyers wrote:
>
>I was just concerned about eventual conflicts if relay.c gets removed,
>given that there does not seem to be many (any ?) users left. But I
>won't be managing the conflicts, so, again, feel free to merge it.
>

blktrace is still using it, AFAIK.
