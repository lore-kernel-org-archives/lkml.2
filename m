Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab2EFJgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 05:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab2EFJgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 05:36:38 -0400
Message-ID: <4FA6460C.8020702@redhat.com>
Date: Sun, 06 May 2012 12:36:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com> <4F9777A4.208@linux.vnet.ibm.com> <20120426234535.GA5057@amt.cnet> <4F9A3445.2060305@linux.vnet.ibm.com> <20120427145213.GB28796@amt.cnet> <4F9B89D9.9060307@linux.vnet.ibm.com> <20120501013459.GB10142@amt.cnet> <4FA0C607.5010002@linux.vnet.ibm.com> <20120502210701.GA12604@amt.cnet> <4FA26B6E.408@linux.vnet.ibm.com> <20120505140836.GC11842@amt.cnet>
In-Reply-To: <20120505140836.GC11842@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 05:08 PM, Marcelo Tosatti wrote:
> It would be better if all these complications introduced by lockless
> updates can be avoided, say using A/D bits as Avi suggested.

Note that using A/D bits introduces new tradeoffs (when just a few bits
are dirtied per iteration, we reduce guest overhead, but increase host
overhead, since it has to scan a large number of sptes), and also a
large fraction of deployed systems don't have A/D bits support.  But it
should affect our thinking - since in the long term all hosts will have it.

-- 
error compiling committee.c: too many arguments to function

