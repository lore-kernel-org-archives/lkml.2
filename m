Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0IAQgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:36:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58853 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab0IAQgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wFsZnTgDMIZcXllT1jwyg9MJw/CGDmB7J54DeWBJZrKRB0UxewH0JBHCTbvQNPiPMA
         8dedYXvKYYnv5e+Eyz7ZWb3E4LqcF9TrWhxwdTJrM62P7daC9kzCbwfMkeLHIsxZiaGf
         /5W/VP3mkVqCIIH3yFvu90TlPb6scgaCXn14k=
Date: Wed, 1 Sep 2010 20:36:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [lockup detector] sync touch_*_watchdog back to
	old semantics
Message-ID: <20100901163632.GA6506@lenovo>
References: <wjkv24h3mpbpnoxk45o0ts96.1283355915765@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wjkv24h3mpbpnoxk45o0ts96.1283355915765@email.android.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 11:51:12AM -0400, Don Zickus wrote:
> Top posting because droid won't let me bottom post
> 
> This patch was the result of a regression with acpi and preempt.
> Akpm asked that I not change the semantics of the old touch_nmi_watchdog.
> So I tried to revert to the old behaviour.
> 
> Sorry for not properly explaining that.
> 

yup, stareing at old behaviour I think there is a place where we could
get rid of traversing all cpus: native_cpu_up() -- I don't get the reason why
watchdog counter should be reset on every other cpu as well. Perhaps
I miss something. On the other hands I think changing behaviour of
touch_nmi_watchdog just for one entry might not be worth thing to do :)

> Cheers,
> Don
> 
> Ingo Molnar <mingo@elte.hu> wrote:
> 
...
> >Ok - can you cite the old watchdog code, did it really do a nr_cpus 
> >loop?
> >
> >Thanks,
> >
> >	Ingo

	-- Cyrill
