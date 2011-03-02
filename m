Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab1CBQzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:55:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49858 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab1CBQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iHinPBJM/D1Wpd3zJoN4ZHb15h+ljJlF0T6jP/r2Yqc6hmVjEc6RoUaBGCEMtoOFyQ
         clv1Daeb7YybCoYDXRbbDfqp7Aqn9L1cZewTytAN+EBCsQllNL3c3Ovz1YAh6Xt9pw8I
         kplds3dZioMMUtW3IkEmBuP8RBWPOirR6avjs=
Date: Wed, 2 Mar 2011 17:55:45 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table
 handling
Message-ID: <20110302165545.GR3319@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
 <4D6E6D52.8030901@kernel.org>
 <20110302163729.GQ3319@htj.dyndns.org>
 <4D6E7459.6050706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E7459.6050706@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 08:46:17AM -0800, Yinghai Lu wrote:
> > * I don't think it's gonna matter all that much.  It's one time and
> >   only used if emulation is enabled, but then again yeap MAX_NUMNODES
> >   * MAX_NUMNODES can get quite high, but it looks way too complicated
> >   for what it achieves.  Just looping over enabled nodes should
> >   achieve about the same thing in much simpler way, right?
> 
> what kind of excuse to put inefficiency code there!

Complexity of a solution should match the benefit of the complexity.
Code complexity is one of the most important metrics that we need to
keep an eye on.  If you don't do that, the code base becomes very ugly
and difficult to maintain very quickly.  So, yes, some amount of
execution inefficiency is acceptable depending on circumstances.
Efficiency too is something which should be traded off against other
benefits.

In this case, it's not a performance critical path at all and similar
level of efficiency can be achieved in much simpler way, so let's do
that, okay?

Thanks.

-- 
tejun
