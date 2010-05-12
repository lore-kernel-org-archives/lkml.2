Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab0ELThF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:37:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37681 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab0ELThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:37:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=tX5tXNGWlsgI3PIN+CVr5eOaM/pYhmQKB9+9VvIS/2ELyom+DAdxeAdbU6f4UJtAp
	0iuHPdBISi80AJEshngDQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTikyXpXKhyy2oZxAF5ums2go2qie0ShOGt2dtHBH@mail.gmail.com>
References: <1273669541.3086.24.camel@localhost>
	 <j2n6599ad831005121201za5fd85bpfc4fa2304a81acaf@mail.gmail.com>
	 <AANLkTilLXWEYHJZCoNk1Tb4P8qgjK-zoVZSg1pDhR-3I@mail.gmail.com>
	 <h2z6599ad831005121220h7956eb62yeea13626093b4a6e@mail.gmail.com>
	 <AANLkTikyXpXKhyy2oZxAF5ums2go2qie0ShOGt2dtHBH@mail.gmail.com>
Date: Wed, 12 May 2010 12:36:57 -0700
Message-ID: <m2x6599ad831005121236ufa1bff7fz78423b1fb6b513e7@mail.gmail.com>
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

On Wed, May 12, 2010 at 12:29 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
>> I think the idea is reasonable - the only way that I could see it
>> breaking someone would be code that currently does something like:
>>
>> mkdir A
>> mkdir B
>> echo 1 > A/mem_exclusive
>> echo 1 > B/mem_exclusive
>> echo $mems_for_a > A/mems
>> echo $mems_for_b > B/mems
>>
>> The attempts to set the mem_exclusive flags would fail, since A and B
>> would both have all of the parent's mems.
>>
>
> But would this not fail otherwise?
>

Assuming that mems_for_a and mems_for_b were disjoint, it would be
fine currently.

Paul
