Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab1F1U6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:58:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:13771 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1F1U6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:58:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=kELUKlW7yzBICh+eGNyBaSSLK9paJ5muI2Xilo716HpP57sV71JoMK4WD1bGF4uTJ
	CyX4jGalnCot9VwVSbj7Q==
Date: Tue, 28 Jun 2011 13:58:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: Christoph Lameter <cl@linux.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
In-Reply-To: <4E0A2E26.5000001@gmail.com>
Message-ID: <alpine.DEB.2.00.1106281355010.4229@chino.kir.corp.google.com>
References: <20110626193918.GA3339@joi.lan> <alpine.DEB.2.00.1106281431370.27518@router.home> <4E0A2E26.5000001@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, David Daney wrote:

> On 06/28/2011 12:32 PM, Christoph Lameter wrote:
> > On Sun, 26 Jun 2011, Marcin Slusarz wrote:
> > 
> > > slub checks for poison one byte by one, which is highly inefficient
> > > and shows up frequently as a highest cpu-eater in perf top.
> > 
> > Ummm.. Performance improvements for debugging modes? If you need
> > performance then switch off debuggin.
> 
> There is no reason to make things gratuitously slow.  I don't know about the
> merits of this particular patch, but I must disagree with the general
> sentiment.
> 
> We have high performance tracing, why not improve this as well.
> 
> Just last week I was trying to find the cause of memory corruption that only
> occurred at very high network packet rates.  Memory allocation speed was
> definitely getting in the way of debugging.  For me, faster SLUB debugging
> would be welcome.
> 

SLUB debugging is useful only to diagnose issues or test new code, nobody 
is going to be enabling it in production environment.  We don't need 30 
new lines of code that make one thing slightly faster, in fact we'd prefer 
to have as simple and minimal code as possible for debugging features 
unless you're adding more debugging coverage.
