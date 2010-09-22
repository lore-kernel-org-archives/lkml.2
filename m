Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab0IVXMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 19:12:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12804 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0IVXMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:12:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CpnstdIrejhQjp4p0jstuYvfJUVTefaIWUKHeJm4N5h1wqdVVMPJ9IuEfUAtdMT5P
	ks1fsxoH2lFXbjW/xzRjg==
Date: Wed, 22 Sep 2010 16:12:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
In-Reply-To: <4C9A881B.9010309@zytor.com>
Message-ID: <alpine.DEB.2.00.1009221607590.22070@chino.kir.corp.google.com>
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221220.34066.bjorn.helgaas@hp.com> <4C9A4AAF.3030503@zytor.com> <201009221253.01049.bjorn.helgaas@hp.com> <4C9A51DC.5020009@zytor.com> <alpine.DEB.2.00.1009221541350.22070@chino.kir.corp.google.com>
 <4C9A881B.9010309@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010, H. Peter Anvin wrote:

> > This patch is going to break our userspace parsing scripts if you change 
> > the output format.  Admittedly, we're probably one of the few users who 
> > actually parses this output, but we do have reasons to do it for our 
> > firmware.  If there was some improvement being introduced here, we'd 
> > happily handle multiple regexs (we constantly add new patterns when new 
> > kernels are released), but I'm not seeing how this is better.
> 
> Kernel messages are not an ABI or API.
> 
> The user space API for this stuff is /sys/firmware/memmap.
> 

I'm referring to using [start, start + addr - 1] in the output, like 
/sys/firmware/memmap does, as opposed to [start, start + addr].  Is it not 
valuable to include the actual e820 map in some way, especially when you 
have your own BIOS?  We've always used this output since it isn't 
available later.

Another use of this information that people may already be using it for is 
ensuring the memmap= on the command line is parsed correctly.

So, again, I'm looking for the benefit here in this patch and it's not 
immediately apparent to me.
