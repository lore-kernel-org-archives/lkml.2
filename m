Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab0ELTUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:20:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab0ELTUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:20:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=MbaT24Vix8vRzq9v1bnlUeedgpIABSQd6EBW6udMFO4jbCMwVy/tloQRJe2F5AeNz
	0zAl57pSvsghYVX1YsVsQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTilLXWEYHJZCoNk1Tb4P8qgjK-zoVZSg1pDhR-3I@mail.gmail.com>
References: <1273669541.3086.24.camel@localhost>
	 <j2n6599ad831005121201za5fd85bpfc4fa2304a81acaf@mail.gmail.com>
	 <AANLkTilLXWEYHJZCoNk1Tb4P8qgjK-zoVZSg1pDhR-3I@mail.gmail.com>
Date: Wed, 12 May 2010 12:20:33 -0700
Message-ID: <h2z6599ad831005121220h7956eb62yeea13626093b4a6e@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Paul Menage <menage@google.com>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: balbir@linux.vnet.ibm.com, peterz@infradead.org, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 12:10 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
> On Wed, May 12, 2010 at 9:01 PM, Paul Menage <menage@google.com> wrote:
>> What about the case where some subset of the parent's mems/cpus are
>> given to a child with the exclusive flag set?
>>
>
> As I mentioned in the TODO, it is still to be handled.

Oops, sorry, just read the patch :-)

> But it should
> simply exclude those mems/cpus which are exclusive. It was a bit more
> involved than the effort I wanted to put in before gauging the
> reactions.

I think the idea is reasonable - the only way that I could see it
breaking someone would be code that currently does something like:

mkdir A
mkdir B
echo 1 > A/mem_exclusive
echo 1 > B/mem_exclusive
echo $mems_for_a > A/mems
echo $mems_for_b > B/mems

The attempts to set the mem_exclusive flags would fail, since A and B
would both have all of the parent's mems.

Paul
