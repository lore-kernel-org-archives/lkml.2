Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab1ADFNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:13:25 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47121 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1ADFNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RVCYYj6qwPk9zC2jRCSh2h4J0+bwG9Ix8DQ8H9ddKtYqO+dVFs2TMbfa6aG4B7xOGz
         IThXPCaUaOgiXulDijkzvFvSQYdtz4kvOkTiLHTl8diVJ8WhucNVLkl0l2c7dUuyxm02
         mGdxopTkqAsdhbTJ7j/ihiFklUfJT9keXMSrQ=
Date: Tue, 4 Jan 2011 06:13:14 +0100
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the percpu tree
Message-ID: <20110104051314.GA6748@mtj.dyndns.org>
References: <20110104152105.5cc7c3a9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104152105.5cc7c3a9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

On Tue, Jan 04, 2011 at 03:21:05PM +1100, Stephen Rothwell wrote:
> After merging the percpu tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> arch/x86/kernel/cpu/mcheck/therm_throt.c: In function 'intel_thermal_interrupt':
> arch/x86/kernel/cpu/mcheck/therm_throt.c:368: error: implicit declaration of function 'this_cpu_has'
> 
> Caused by commit 6ac0bb7148b93fb40bccba5dff06d51a3e3ea283 ("x86: use
> this_cpu_has for thermal_interrupt").
> 
> this_cpu_has() does not exist anywhere except in this introduced usage.
> 
> I have used the percpu tree from next-20101231 for today.

My apologies.  I forgot an earlier patch to introduce this_cpu_has()
macro.  I've reverted the offending commit.

Thank you.

--
tejun
