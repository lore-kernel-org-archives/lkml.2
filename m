Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab0DPBQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 21:16:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63034 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab0DPBQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 21:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=xgAo8ckJshXRfCoOCWxWHMJtjomlTzEk+Wh58Lop0GmtiNEFRN3t3NH6y5qLhHxIs9
         h7Nc6lUC11bApVPUJGs1l/8bxfiY4kKSOSHmqOXqbXeTCCRjrE6c3plmXFuJR3kOlL7O
         TrGTQhkxd8YGqyZOdzBr/CPjpp2S54Npiicho=
Message-ID: <4bc7ba4f.cb3cdc0a.3ebe.0678@mx.google.com>
Date: Thu, 15 Apr 2010 18:15:59 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Lockup inside of stop_machine() during modprobe aes (was Re:
	Another AR5008 hang)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath9k@venema.h4ckr.net,
       Herbert Xu <herbert@gondor.hengli.com.au>
In-Reply-To: <20100415172205.c1e57636.akpm@linux-foundation.org>
References: <4bb0e2da.04c2f10a.32b2.11ae@mx.google.com>
	<1269928986.3927.5.camel@jlt3.sipsolutions.net>
	<4bb1f940.47c2f10a.3469.609b@mx.google.com>
	<4bb235fb.0baa660a.5b56.ffffa9c2@mx.google.com>
	<4bbb7896.48c3f10a.30b9.365b@mx.google.com>
	<20100415172205.c1e57636.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 17:22:05 -0400, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 06 Apr 2010 11:08:22 -0700 (PDT) Ben Gamari <bgamari.foss@gmail.com> wrote:
> > ...
> > In particular, it seems that the kernel is deadlocking inside of
> > stop_machine() while flushing workqueues.
> > ...
> 
> My guess would be that ieee80211 is calling crypto->request_module()
> under rtnl_lock, and the fact that rtnl_lock is held is causing
> modprobe->stop_machine to not complete.
> 
> > P.S. I am now quite certain that I was mistaken in saying that 2.6.33 was
> > affected. This seems to just be a 2.6.34 issue.
> 
> OK, thanks, I'll ask Rafael and Maciej to track this as a post-2.6.33
> regression, probably wireless.

Thanks!

- Ben

