Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1EPInz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:43:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33298 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1EPIny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NVsvIEo6HAi6FFRRfyLcbTnp10wI6apZDOlGk2XZ22piEVQeC9sVS/tJpauRbBE09w
         oflDUa1oOnfQLkZM7cmJ5oRVCYdMWmyd2CQBL9/ZE1kfhkJz2QOERfBGlmYJKvT+/tbh
         WBRM/nokYloii7YmRBIcyYuhbs+3nTxOwUwbM=
Date: Mon, 16 May 2011 10:43:50 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: getter PTRACE_GETSIGINFO should not modify anything  [Re:
 [PATCH 11/11] ptrace: implement group stop notification for ptracer]
Message-ID: <20110516084350.GO23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-12-git-send-email-tj@kernel.org>
 <20110515140232.GB31855@host1.jankratochvil.net>
 <20110515142827.GF23665@htj.dyndns.org>
 <20110515171748.GA25216@host1.jankratochvil.net>
 <20110515172811.GM23665@htj.dyndns.org>
 <20110515200654.GA32659@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515200654.GA32659@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 15, 2011 at 10:06:54PM +0200, Jan Kratochvil wrote:
> You are introducing new API which requires new codepaths in every
> debugger-like program using it.  I do not find the "not deviating" reason as
> valid for making the _new_ API parts needlessly imperfect.  Otherwise in the
> next step we will want to fix the new imperfect parts and - there will be
> three APIs that time to be supported in each debugger-like program depending
> on how old kernel versions the debugger wants to support.

There's distinction between "broken" and "ugly".  If it's ugly but
functional, you don't need to "fix" it.  What we have is a broken ugly
one and my primary goal is fixing the broken part.  I don't
necessarily object to making it pretty but that's not my primary goal.

> Sure the changes should be still small - I do not ask for making unrelated new
> changes; just making the already needed changes perfect in their scope.

Perfect is enemy of good.  I'll listen to your and other's suggestions
but given the rather subpar history of ptrace and its development am
not too convinced that the existing ideas or directions were
especially effective.

Frankly, I think the biggest disease was this obsession with
perfection.  Whether ptrace is slightly prettier or not, or whether it
can do the obscure feature three enterprise customers requested
doesn't matter all that much.  Let's leave them alone and concentrate
on fixing mainstream use cases.

So, I'm gonna push back quite a bit unless it actually compromises
functionality or correctness.

Thank you.

-- 
tejun
