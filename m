Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1JLBW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 21:22:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9150 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1JLBWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 21:22:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=XB1ChqhTyEmeQ6zwUt3KpI3IT6mgqNDYFUlcbIWL2y9LbnpoxBnM6Ulp4zQK1yej7
	KNKaNgyliyf06h76sVKqA==
Date: Tue, 11 Oct 2011 18:22:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <efault@gmx.de>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <htejun@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch] cpusets, cgroups: disallow attaching kthreadd
In-Reply-To: <1318352236.6194.22.camel@marge.simson.net>
Message-ID: <alpine.DEB.2.00.1110111821270.10060@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com> <1316770936.6641.11.camel@marge.simson.net>
 <1316775204.7562.9.camel@marge.simson.net> <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com> <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net> <1318233815.6527.5.camel@marge.simson.net> <20111010164339.GA8100@google.com>
  <1318342087.14615.5.camel@twins> <1318352236.6194.22.camel@marge.simson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Mike Galbraith wrote:

> I don't know of anything other than kthreadd where moving it here, or
> over yonder matters one bit.
> 

Clear PF_THREAD_BOUND for watchdog or migration kthreads and change their 
affinity or move them into a cpuset where cpuset.cpus doesn't include the 
cpu they are bound to and it'll be obvious.
