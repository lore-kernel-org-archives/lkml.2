Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1DUD7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 23:59:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47511 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1DUD7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 23:59:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110420193145.GA15439@merkur.ravnborg.org>
References: <20110420084449.23741.45580.stgit@ponder> <20110420193145.GA15439@merkur.ravnborg.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 20 Apr 2011 21:58:53 -0600
X-Google-Sender-Auth: Bc00Vb0Br4l5sTjutU3lhPsIVgI
Message-ID: <BANLkTimYJu5BeCb3i64KVTDcTn8SnFsPXQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: stop exporting irq_map
To: Sam Ravnborg <sam@ravnborg.org>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 1:31 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> +
>>  irq_hw_number_t virq_to_hw(unsigned int virq)
>>  {
>>       return irq_map[virq].hwirq;
>>  }
>>  EXPORT_SYMBOL_GPL(virq_to_hw);
>
> General comment...
> kernel/irq/* denote the virtual irq numbers "irq".
> powerpc uses "virq" for the same.

I might do that, but I'm early in this refactoring work yet so I'm not
entirely sure what the final result is going to look like.  At least
with the 'virq_' prefix I can find the powerpc specific functions that
are candidates for refactoring or replacing.

g.

>
> Sometimes it is confusing that two different names is used
> for the same thing.
>
> The intent of this patch is to centralize access to a common data structure,
> but this could also be a good candidate for a terminology shift if
> this is considered.
>
> "git grep virq" shows a lot of hits - especially in arm, powerpc.
> So what I suggest is obviously only a small step in the direction
> of using "irq" all over.
>
>        Sam
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
