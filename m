Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab1FQOXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:23:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44086 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab1FQOXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:23:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uOe/GuvvnFwmTPvf2KbgslauWDBewskOoQw7lS3D2VU0hpLOqPC4+rFVxVwL1VurhI
         +SJDb9j3wQ3qStmCRy2A1LogUZ6C83k0ST/c1L58MnPlaSEdO7zrKZZDdQIdooH8uoZs
         y+bdSqOr3034Oea90su/uBdc3E+MhgA63qyQw=
Message-ID: <4DFB6345.3080007@gmail.com>
Date: Fri, 17 Jun 2011 08:23:01 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 4/6] perf record: add time-of-day option
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com> <1307490964-24714-1-git-send-email-dsahern@gmail.com> <20110617141425.GD25197@somewhere.redhat.com>
In-Reply-To: <20110617141425.GD25197@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 08:14 AM, Frederic Weisbecker wrote:
> 
> So I feel uncomfortable with this tod_sample_type hack. I think we can't really continue
> with this fixed sample_type per session given the kind of hacks that involves.
> 
> One thing we could do is to split session->sample_type into an array with one sample
> type per event type (hardware, breakpoint, software, tracepoint).
> 
> And then each builtin tool can provide their constraints on top of these values:
> 
> - builtin-report wants sample_type[HARDWARE] == sample_type[SOFTWARE] == sample_type[TRACEPOINT] == sample_type[BREAKPOINT]
>   although that may be tunable by the time but we can start with that.
> - builtin-script has no specific constraints, except that sample_type[i] meets what the user passed as a parameter
> - etc..
> 
> Constraints can probably default to sample_type[i] == sample_type[i+1] to mimic the current behaviour. Then tools
> can override that.
> 
> What do you think?

I started working on sample_type refactoring right after sending this
patchset (though I got sidetracked). Each evsel in the list has a
perf_attr struct which has a sample_type. Why not use that which allows
events to have their own sample type - versus a type per event type?

I'll see if I can get back to it in the next few days and get a better
idea of the pain involved with the refactoring.

David
