Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0L3CPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 21:15:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44351 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0L3CPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 21:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y88SlU34wjWL4undl/ttK0kpkQxYtelIi8mUw6w2HHM/2syOrUTvHvBXafVEVe297j
         4TWXRybk6WFJIixXG6YHp6MGw6O5gCRHFhyeujgCXuBvB9yiAItKVk4Z3Wlu4o4ilZZh
         9H/529JIjquiA+6NqtnvS59zJiZ7KxZqhrIpE=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=jnHFThon6pApmozJ0dmu5Wimd46=t-NrmOWDW@mail.gmail.com>
References: <AANLkTi=jnHFThon6pApmozJ0dmu5Wimd46=t-NrmOWDW@mail.gmail.com>
Date: Thu, 30 Dec 2010 10:15:52 +0800
Message-ID: <AANLkTi=TR+gO6kdA1M5XkF-MTaUVBzXXtngmpNmwTYuX@mail.gmail.com>
Subject: Re: Question about in_interrupt() semantics with regard to softirqs.
From: Yong Zhang <yong.zhang0@gmail.com>
To: Justin Seyster <jrseys@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 4:27 AM, Justin Seyster <jrseys@gmail.com> wrote:
> I'm trying to understand the in_interrupt() function, and it seems
> that it will return true for normal, non-interrupt code that disables
> bottom half processing.  It looks like that behavior is intentional,
> but I don't understand why it's designed that way.  I'm sorry if I'm
> stating something obvious here; it would help me a lot if somebody
> double checked my reasoning!
>
> in_interrupt() checks a hardirq count and a softirq count, but I found
> out that these two counts behave very differently.  The hardirq count
> tracks the nesting depth of hardware interrupts (which is what I would
> expect), but the softirq count behaves like the preempt count,
> tracking whether softirqs are currently enabled.
>
> So if normal code (executing on behalf of a user process) disables
> softirqs with local_bh_disable(), it will get a true return value from
> in_interrupt() until it finally reenables them.  But disabling
> hardirqs will not have the same effect: the hardirq count is
> unchanged, and in_interrupt() will still return false.
>
> My question is: is there a design decision for this asymmetry between
> hard and softirqs?  Also, is there a function that does what I really
> wanted, which is to return true iff execution is actually in
> bottom-half context?

For the function you want, you can take a look at commit:
75e1056f5c57050415b64cb761a3acc35d91f013

Thanks,
Yong

-- 
Only stand for myself
