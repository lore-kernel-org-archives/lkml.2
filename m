Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1DOQMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:12:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64307 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab1DOQMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=clek0w0yVH1brQJwOm0aoC2VcafbReuKbcxLG/9U9QyO7h3hmhZzk2NMvQutWAkCdh
         Bpxtkr0OWhU2ibVctglqxYLvBOuyvIuQx6EJKbJ3xQzKRHQ0im1UQQ6zf0KZDKSXU7SI
         Bly/aF+uRuyJKcLI9Ez5KREKnpbaOtFNFznPY=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "ext Andrea Arcangeli" <aarcange@redhat.com>,
        "Phil Carmody" <ext-phil.2.carmody@nokia.com>
Cc: akpm@linux-foundation.org, cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] mm: make read-only accessors take const pointer
 parameters
References: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <20110415145133.GO15707@random.random>
 <20110415155916.GD7112@esdhcp04044.research.nokia.com>
Date: Fri, 15 Apr 2011 18:12:33 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtzly7dk3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110415155916.GD7112@esdhcp04044.research.nokia.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011 17:59:16 +0200, Phil Carmody wrote:
> I'm just glad this wasn't an insta-nack, as I am quite a fan of
> consts, and hopefully something can be worked out.

I feel you man.  Unfortunately, I think that const, since it's an
after-thought, is not very usable in C.

For instance, as you've pointed in your patch, the "_ro" suffix
is sort of dumb, but without it compound_head would have to take
const and return non-const (like strchr() does) which is kinda
stupid as well.

What's more, because of lack of encapsulation, “const struct page”
only means that the object is const but thighs it points to aren't.
As such, const does not really play that well with structs anyway.

const is, in my opinion, one of those things C++ actually got
right (or close to right).

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
