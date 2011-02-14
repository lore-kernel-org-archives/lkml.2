Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1BNS7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:59:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43420 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1BNS7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:59:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=G1YrMfVOxI8QiRsqVVSeLKcobDuElVEvUMGdeS1U76C31YKPeYLqeuNt9EjzWDLHlf
         zisH/9/FaNsdAX6ZD4+kHb58/ElE0pnjtdRrN/4ctgO4ogR1OjrtBNfQ23gJONU2mlCm
         z0bOaVCWsaHntkDDYJlU5gVERmqMjBs0hZ4SA=
MIME-Version: 1.0
In-Reply-To: <20110214173910.GA15847@redhat.com>
References: <20110204105343.GA12133@htj.dyndns.org> <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org> <201102132325.55353.vda.linux@googlemail.com>
 <20110214153149.GB8761@redhat.com> <AANLkTikYf1CE41x6FjE6FiZ40v8taRSy8aZ3-5tjAvok@mail.gmail.com>
 <20110214173910.GA15847@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 14 Feb 2011 19:59:19 +0100
Message-ID: <AANLkTi=KfK9AUnUfS1BUVCifpohoJZWXLpTnznRcshw5@mail.gmail.com>
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after PTRACE_ATTACH
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 6:39 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> Ah, I see. Is there any way debugger can distinguish between these two
>> different stops?
>
> IIRC, the (only?) way to distinguish is to check last_siginfo != NULL
> via ptrace(PTRACE_GETSIGINFO).

Right. ptrace(PTRACE_GETSIGINFO) will fail on non-signal-delivery stops.
Thus, it can be used to distinguish different kinds of SIGSTOPs in my example.
-- 
vda
