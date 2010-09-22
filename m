Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0IVWqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:46:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:46630 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab0IVWqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:46:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZLHPbd8OPvZa0hjMslzB6N9JfgPachId9pM0+8TzG/T8rTkVKrbVf0DJsT0mkhbiy
	0/W864h/nCWxYncKj28eg==
Date: Wed, 22 Sep 2010 15:46:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
In-Reply-To: <4C9A51DC.5020009@zytor.com>
Message-ID: <alpine.DEB.2.00.1009221541350.22070@chino.kir.corp.google.com>
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221220.34066.bjorn.helgaas@hp.com> <4C9A4AAF.3030503@zytor.com> <201009221253.01049.bjorn.helgaas@hp.com> <4C9A51DC.5020009@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010, H. Peter Anvin wrote:

> > It's true, they don't (well, everything below 4G still lines up, but
> > not above that).  Do you like this any better?
> > 
> 
> That's fine with me.  I don't mind the [mem ] bracket either if you
> think it's useful.
> 

This patch is going to break our userspace parsing scripts if you change 
the output format.  Admittedly, we're probably one of the few users who 
actually parses this output, but we do have reasons to do it for our 
firmware.  If there was some improvement being introduced here, we'd 
happily handle multiple regexs (we constantly add new patterns when new 
kernels are released), but I'm not seeing how this is better.
