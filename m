Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161533Ab1FALTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 07:19:51 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:52430 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161268Ab1FALTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 07:19:05 -0400
Date: Wed, 1 Jun 2011 21:18:42 +1000
From: CaT <cat@zip.com.au>
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Avi Kivity <avi@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
Message-ID: <20110601111841.GB3956@zip.com.au>
References: <alpine.LSU.2.00.1105311517480.21107@sister.anvils>
 <4DE589C5.8030600@fnarfbargle.com>
 <20110601011527.GN19505@random.random>
 <alpine.LSU.2.00.1105312120530.22808@sister.anvils>
 <4DE5DCA8.7070704@fnarfbargle.com>
 <4DE5E29E.7080009@redhat.com>
 <4DE60669.9050606@fnarfbargle.com>
 <4DE60918.3010008@redhat.com>
 <4DE60940.1070107@redhat.com>
 <4DE61A2B.7000008@fnarfbargle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE61A2B.7000008@fnarfbargle.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 06:53:31PM +0800, Brad Campbell wrote:
> I rebooted into a netfilter kernel, and did all the steps I'd used
> on the no-netfilter kernel and it ticked along happily.
> 
> So the result of the experiment is inconclusive. Having said that,
> the backtraces certainly smell networky.
> 
> To get it to crash, I have to start IE in the VM and https to the
> public address of the machine, which is then redirected by netfilter
> back into another of the VM's.
> 
> I can https directly to the other VM's address, but that does not
> cause it to crash, however without netfilter loaded I can't bounce
> off the public IP. It's all rather confusing really.
> 
> What next Sherlock?

I think you're hitting something I've seen. Can you try rewriting
your firewall rules so that it does not reference any bridge
interfaces at all. Instead, reference the real interface names
in their place. I'm betting it wont crash.

(netdev added to CC since we're aleady bouncing there)

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.dailytelegraph.com.au/news/wacky/indeed/story-e6frev20-1111118083480
