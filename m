Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab1DTL23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:28:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64300 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1DTL21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=B/G6bpU9NlhgZkhJibZ7Brl9bC7YCa3RUlBy4G0d8rJhJYS7yZPCDsW8MD5mY/l2l0
         NKfICjdjr6JN4/O8NB4sdQkJB/YugoBKoLmRTwf4wuf7KSLnw17k2UgxM4ViZ6muyTX1
         b6+lIN3b60Agi7V9NgVlP6QbYPLhhj8DEjbNo=
MIME-Version: 1.0
In-Reply-To: <20110420112020.GA31296@parisc-linux.org>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com>
	<BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com>
	<20110420161615.462D.A69D9226@jp.fujitsu.com>
	<BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com>
	<20110420112020.GA31296@parisc-linux.org>
Date: Wed, 20 Apr 2011 14:28:26 +0300
X-Google-Sender-Auth: fr-Jl-L8jV6hWDnylkotoPCH8DY
Message-ID: <BANLkTim+m-v-4k17HUSOYSbmNFDtJTgD6g@mail.gmail.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
From: Pekka Enberg <penberg@kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Wed, Apr 20, 2011 at 10:34:23AM +0300, Pekka Enberg wrote:
>> That part makes me think the best option is to make parisc do
>> CONFIG_NUMA as well regardless of the historical intent was.

On Wed, Apr 20, 2011 at 2:20 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> But it's not just parisc.  It's six other architectures as well, some
> of which aren't even SMP.  Does !SMP && NUMA make any kind of sense?

IIRC, we actually fixed SLAB or SLUB to work on such configs in the past.

On Wed, Apr 20, 2011 at 2:20 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> I think really, this is just a giant horrible misunderstanding on the part
> of the MM people.  There's no reason why an ARM chip with 16MB of memory
> at 0 and 16MB of memory at 1GB should be saddled with all the NUMA gunk.

Right. My point was simply that since x86 doesn't support DISCONTIGMEM
without NUMA, the misunderstanding is likely very wide-spread.

                       Pekka
