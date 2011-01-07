Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1AGTz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:55:57 -0500
Received: from smtp-out.google.com ([74.125.121.67]:36053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1AGTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:55:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ac5L6TTZ9Dgzs6Xhlq1ED2ibvM4ffLk5/DoV7TrQKskjqvg9JC8FApCkS27I6S3HU2
         jJFYbWEytRQVX+0v2dVQ==
Date: Fri, 7 Jan 2011 11:55:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Jan Beulich <JBeulich@novell.com>, Tejun Heo <tj@kernel.org>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
In-Reply-To: <20110107151254.GA418@elte.hu>
Message-ID: <alpine.DEB.2.00.1101071148120.31653@chino.kir.corp.google.com>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com> <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com> <4D26D3FD020000780002AED9@vpn.id2.novell.com> <alpine.DEB.2.00.1101070156050.19087@chino.kir.corp.google.com> <4D26F3AE020000780002AF5D@vpn.id2.novell.com>
 <20110107125722.GA23185@elte.hu> <4D272413020000780002B009@vpn.id2.novell.com> <20110107142203.GA12773@elte.hu> <4D2730BE020000780002B040@vpn.id2.novell.com> <20110107151254.GA418@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Ingo Molnar wrote:

> > > Your -stable comment above made it appear to me as if you knew about a 
> > > specific 
> > > system that crashed this way? As long as it's only theoretical i'm not sure 
> > > it 
> > > warrants a -stable backport.
> > 
> > Yes, I do have a system affected (which made me craft the patch
> > in the first place).
> 
> In that case it's very useful to start the commit with:
> 
>   System XYZ crashes during bootup due to a bug in numa= command line option 
>   handling.
> 
> That will also cause me to add an immediate -stable backport tag from me, even if 
> you dont add it. Keeping it all optional and theoretical with 'it may crash' wording 
> just hides the essential piece of information that there's a real system affected by 
> the bug.
> 

I still don't think it meets the stable kernel rules.  The changelog 
explicitly states that we do not want to disable ACPI completely, so the 
only numa= command line option that would possibly be useful on 32-bit is 
numa=off in this case.  If you're compiling a 32-bit kernel for a machine 
with SRAT entries that can't be parsed by the kernel, then there's still 
no explanation as to why CONFIG_NUMA=n won't fix it.
