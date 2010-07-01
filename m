Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab0GABjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 21:39:09 -0400
Received: from tundra.namei.org ([65.99.196.166]:54982 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab0GABjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 21:39:07 -0400
Date: Thu, 1 Jul 2010 11:39:01 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Christoph Hellwig <hch@infradead.org>
cc: Kees Cook <kees.cook@canonical.com>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Yama: add PTRACE exception tracking
In-Reply-To: <20100630073158.GA4453@infradead.org>
Message-ID: <alpine.LRH.2.00.1007011057520.24202@tundra.namei.org>
References: <20100630003844.GE4837@outflux.net> <20100630073158.GA4453@infradead.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Christoph Hellwig wrote:

> Err, no.  This is just a very clear sign that your ptrace restrictions
> were completely wrong to start with and break applications left, right
> and center.  Just get rid of it instead of letting workarounds for your
> bad design creep into the core kernel and applications.

Indeed, I wasn't aware that there were further aspects to this -- I 
thought it was a relatively simple case of restricting a problematic OS 
feature for heavily locked down systems.

This is getting more complicated, with fine-grained security policy now 
being introduced, also with the need to modify applications.

There are several existing LSMs with the ability to control ptrace, but as 
part of a system-wide, coherent, analyzable policy -- often in support of 
specific security models for which there is concrete user demand and 
benefit.

If people won't use any of SELinux, Smack, Tomoyo or AppArmor, then I 
don't think providing an ad-hoc assortment of workarounds with no overall 
design is going to help them either.

If LSMs need to call into common code in Yama, or even do lightweight 
chaining, that's one thing, but for Yama to evolve into yet another 
standalone security scheme, is something entirely different.



- James
-- 
James Morris
<jmorris@namei.org>
