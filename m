Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab0K3J7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:59:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32997 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab0K3J7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FxNy6F7u368Ih8pX4uYcUkEOPgFhsHdPrX4XIDNtG2CQA+F5NEe9a3ifgrJlO7/jKq
         jUFX9PimIA3GLH08k7FffOTMgz9Ydze/ROXvJIlA4jtKjZff8+AmsCNE9nUpkMJNacyo
         EvUzVeHw/Fw87xIqwXhXOJM8/CF4Kj65HlY3U=
Subject: Re: [PATCH v2 4/4] kthread: use kthread_create_on_cpu()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-arch@vger.kernel.org
In-Reply-To: <15903.1291109892@redhat.com>
References: <1291043719.3435.981.camel@edumazet-laptop>
	 <1290972833.29196.90.camel@edumazet-laptop>
	 <20101128224024.GA12300@basil.fritz.box>
	 <1290984712.29196.100.camel@edumazet-laptop>
	 <20101128230146.GB12300@basil.fritz.box>
	 <1290987424.29196.128.camel@edumazet-laptop>
	 <20101129090510.GA15763@basil.fritz.box>
	 <1291023532.3435.29.camel@edumazet-laptop>   <15903.1291109892@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 10:59:01 +0100
Message-ID: <1291111141.2904.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 novembre 2010 à 09:38 +0000, David Howells a écrit :
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > +		p = kthread_create_on_cpu(run_ksoftirqd, hcpu, hotcpu,
> > +					  "ksoftirqd/%d", hotcpu);
> 
> Does kthread_create_on_cpu() need to take hotcpu twice?  Can one of the
> arguments be folded into the other?
> 
> David

The second one is used in a printf() like to build a string, its not
really part of the API..

Caller could do instead :

char name[32];
sprintf(name, "ksoftirqd/%d", whatever_id);
p = kthread_create_on_cpu(run_ksoftirqd, hcpu, hotcpu, name);



