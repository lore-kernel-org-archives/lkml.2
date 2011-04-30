Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1D3MCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:02:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59344 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab1D3MCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FxBhiY321AdROlOD3kj7qS9xpvb6BjvYKHMWbc2N1XzMV0tiiqz7dfFzDf1Gf8UXaE
         UZL0n8lHebm4RlWurFBBJdnDvWKdfkt99Oa5crUZ0JfCrEQroOi41TL0ugZsU+KR0lh5
         p4rqL46TpblZP9GciN9ibz5ayYxuAkF77zyLU=
Date: Sat, 30 Apr 2011 14:02:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/25] x86-64, NUMA: simplify nodedata allocation
Message-ID: <20110430120217.GD29280@htj.dyndns.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
 <1304090924-8197-4-git-send-email-tj@kernel.org>
 <4DBAF40F.8030207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBAF40F.8030207@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 10:23:27AM -0700, Yinghai Lu wrote:
> On 04/29/2011 08:28 AM, Tejun Heo wrote:
> > With top-down memblock allocation, the allocation range limits in
> > ealry_node_mem() can be simplified - try node-local first, then any
> > node but in any case don't allocate below DMA limit.
> > 
> > Remove early_node_mem() and implement simplified allocation directly
> > in setup_node_bootmem().
> 
> keep early_node_mem would be better?

I don't know, maybe, maybe not.  I usually find separating out linear
procedural logic into a function, which is used only once, more
distracting / obfuscating than helpful.

-- 
tejun
