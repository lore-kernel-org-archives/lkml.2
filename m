Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab1ELRVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:21:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48221 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab1ELRVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jnWsTHZHpFqyRiPO7OubFs4AFUudDptZy/4kg5FTAvpag2k9LZBvVwl9r/shE8NsSc
         Mnsl6G2OHcJZd0Y9ig/W7s+fxNK2Tei7FUGteVbnw2a9hQC6jJGn2bhARaDJIAyimmwX
         xhWxDOXIXFxO+8lvfvp3NbulLmrcPAugBR/Jw=
Date: Thu, 12 May 2011 19:21:33 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110512172133.GN1030@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-5-git-send-email-tj@kernel.org>
 <20110509165857.GA30607@redhat.com>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <20110510142033.GY1661@htj.dyndns.org>
 <20110510180811.GB32637@redhat.com>
 <20110511082947.GB1661@htj.dyndns.org>
 <20110512170617.GB20215@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512170617.GB20215@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, May 12, 2011 at 07:06:17PM +0200, Oleg Nesterov wrote:
> > I don't agree.  PTRACE_TRACEME predates PTRACE_ATTACH and is
> > completely redundant.  If you can make the child do PTRACE_TRACEME,
> > you might as well just make it do pause() and PTRACE_SEIZE yourself,
> > so unless there's something PTRACE_SEIZE can't do, I don't think I'll
> > be adding SEIZEME.
> 
> Heh. I think that you are very right technically and I thought the
> same. That is why I never mentioned PTRACE_TRACEME before. In fact
> I never understood why PTRACE_TRACEME exists.
> 
> However. Perhaps this is wrong from the practical pov. SEIZEME can
> simplify the conversion of the existing code. People are lazy, but
> we need the users of PTRACE_SEIZE.

Hmmm... given that the attaching part is somewhat isolated from the
rest of code.  I'm hoping to get away with providing a sample code in
documentation.  :-)

Thanks.

-- 
tejun
