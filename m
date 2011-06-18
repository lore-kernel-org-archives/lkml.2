Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1FRI5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 04:57:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40844 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1FRI5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 04:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=G+HmPOUyJTxtfOz/tDQ3Ahl3JeDwTzxqcquu7xyzfVzN3S5wzJptENYHQefmZ7edlM
         Cycdq2BPz0Mc7ZZJ6/Yf7V3Uya38DJVcRQx2w3gGO6p9tvXc3KlMh17jKV2npKxiqTy+
         c9u0jbrE8FyEcne8Jr7FPCmRl5vdh7+XdjnAk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] ptrace: implement PTRACE_SEIZE
Date: Sat, 18 Jun 2011 10:57:02 +0200
User-Agent: KMail/1.8.2
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
References: <1308043218-23619-1-git-send-email-tj@kernel.org> <201106180959.38847.vda.linux@googlemail.com> <20110618083559.GK2611@htj.dyndns.org>
In-Reply-To: <20110618083559.GK2611@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106181057.02477.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 10:35, Tejun Heo wrote:
> Hello,
> 
> On Sat, Jun 18, 2011 at 09:59:38AM +0200, Denys Vlasenko wrote:
> > ...unless we plan to introduce PTRACE_O_TRACESTOP (with value 0x00000080)
> > which enables PTRACE_INTERRUPT and stop notifications independently
> > of PTRACE_SEIZE. Which would be very useful for e.g. strace.
> 
> I know you're a big fan of those option flags but I don't really see
> the added value in making these behaviors optional rather than keeping
> things backward compatible - ie. introducing new event needed to be
> gated somehow so the O flags but SEIZE itself serves as a big gate
> anyway so I don't see much point in introducing multiple selectable
> behaviors.  It's not like PTRACE_O_TRACESTOP is gonna make anything
> drastically easier or reduce significant amount of overhead.

I explained this already. strace code is a bit complex, and adding
more complexity so that it uses PTRACE_SEIZE if available, but PTRACE_ATTACH
if it is not, will add some PITA.

Considering that strace does not want PTRACE_SEIZE per se, it only wants
to have a way to properly see and handle group stops, having an option
to enable *only that functonality* without having to use PTRACE_SEIZE
will be useful for strace.

-- 
vda
