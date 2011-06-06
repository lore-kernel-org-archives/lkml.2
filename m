Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab1FFQWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:22:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43346 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab1FFQWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:22:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eD0DBWUWFmn82IwbgQ4aGf97Bw1Dwn9WNSXgKvkPGQFIPNCA2INYTp1BqoHFFw7SSb
         5XSnnogTrQsDZ8oLUTn42g7iKBxIYGmYQzULuK+bS5YYxFbhwqRuhuuKqfOYMlZF0Sa+
         Wn9pjQAIFW3c0KxcTsNfdNObQPEoNqGEt+1s4=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307376989.2322.171.camel@twins>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 18:22:29 +0200
Message-ID: <1307377349.3098.65.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 18:16 +0200, Peter Zijlstra a écrit :

> Hmm, wouldn't that still be susceptible to the zero-page thing if: we
> create a writable private file map of a sparse file, touch a page and
> then remap the thing RO?
> 
> 
> 

Also I am not sure how MAP_PRIVATE could be affected. If we still try a
RW gup()... It will allocate a page for us, instead of still pointing to
shared one.

On previous kernel, the application using read-only mapping could use
MAP_PRIVATE or MAP_SHARED with same 'behavior'


