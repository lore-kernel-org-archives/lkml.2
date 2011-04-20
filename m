Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1DTLUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:20:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63771 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1DTLUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:20:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=k/5kD2PytxJwNgrGmj0xXG0CYJ0Q1Ffe5htYJ9sVqjnjpeawRME/zEWt6tyTcwxW4F
         CEbTXhtjlPAjstviP7y0VApoJ6UXfAntGFmq7DqFWel9f8/i74wxk1dJ23EsfgOVqXMA
         5/fqnnNu22YmNMIPkf704AVbmOsxFfLmdfe08=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Andrea Arcangeli" <aarcange@redhat.com>,
        "Artem Bityutskiy" <dedekind1@gmail.com>
Cc: "Phil Carmody" <ext-phil.2.carmody@nokia.com>, akpm@linux-foundation.org,
        cl@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] mm: make read-only accessors take const pointer
 parameters
References: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <20110415145133.GO15707@random.random>
 <20110415155916.GD7112@esdhcp04044.research.nokia.com>
 <20110415160957.GV15707@random.random> <1303291717.2700.20.camel@localhost>
Date: Wed, 20 Apr 2011 13:20:19 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vt8hr5j73l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1303291717.2700.20.camel@localhost>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 11:28:37 +0200, Artem Bityutskiy <dedekind1@gmail.com>  
wrote:
> I think it is good when small core functions like this are strict and
> use 'const' whenever possible, even though 'const' is so imperfect in C.
>
> Let me give an example from my own experience. I was writing code which
> was using the kernel RB trees, and I was trying to be strict and use
> 'const' whenever possible. But because the core functions like 'rb_next'
> do not have 'const' modifier, I could not use const in many many places
> of my code, because gcc was yelling. And I was not very enthusiastic to
> touch the RB-tree code that time.

The problem is that you end up with two sets of functions (one taking const
another taking non-const), a bunch of macros or a function that takes const
but returns non-const.  If we settle on anything I would probably vote for
the last option but the all are far from ideal.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
