Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab1CXR4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:56:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37654 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1CXR4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:56:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=oPTDSvoxHpu62a61on65G+SPPB0v4MCrQjkOwVKMK1xpAtahLqP71Mo6Psmgkfq4td
         xdhZ5OKzFMwTGpkSA5iaDKgwjc5LeeCfoZrd3HM00NRaTguPGx7K/DX5Q5PWUinP4bwx
         YMMoeegW/crXEPbVhqpSTKtdbhdIgTzvA0R1s=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103241242450.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	<20110324142146.GA11682@elte.hu>
	<alpine.DEB.2.00.1103240940570.32226@router.home>
	<AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
	<20110324172653.GA28507@elte.hu>
	<alpine.DEB.2.00.1103241242450.32226@router.home>
Date: Thu, 24 Mar 2011 19:56:35 +0200
X-Google-Sender-Auth: jYAvL6fE08xpA-QjGEDlQm7Esk4
Message-ID: <AANLkTimMcP-GikCCndQppNBsS7y=4beesZ4PaD6yh5y5@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Ingo Molnar wrote:
>> > How does alternative_io() work? Does it require
>> > alternative_instructions() to be executed. If so, the fallback code
>> > won't be active when we enter kmem_cache_init(). Is there any reason
>> > check_bugs() is called so late during boot? Can we do something like
>> > the totally untested attached patch?
>>
>> Does the config i sent you boot on your box? I think the bug is pretty generic
>> and should trigger on any box.

On Thu, Mar 24, 2011 at 7:43 PM, Christoph Lameter <cl@linux.com> wrote:
> The bug should only trigger on old AMD64 boxes that do not support
> cmpxchg16b.

Yup. Ingo is it possible to see /proc/cpuinfo of one of the affected
boxes? I'll try your config but I'm pretty sure the problem doesn't
trigger here. Like I said, I think the problem is that alternative
instructions are not patched early enough for cmpxchg16b emulation to
work for kmem_cache_init(). I tried my check_bugs() patch but it hangs
during boot. I'll see if I can cook up a patch that does
alternative_instructions() before kmem_cache_init() because I think
those *should* be available during boot too.

                        Pekka
