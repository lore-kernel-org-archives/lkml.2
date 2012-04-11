Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab2DKKt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:49:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2DKKt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:49:28 -0400
Message-ID: <4F8561A7.80604@redhat.com>
Date: Wed, 11 Apr 2012 13:49:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: zhangyanfei <zhangyanfei@cn.fujitsu.com>, mtosatti@redhat.com,
        ebiederm@xmission.com, luto@mit.edu, dzickus@redhat.com,
        paul.gortmaker@windriver.com, gregkh@suse.de, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F84E0DF.8040206@cn.fujitsu.com> <20120411102136.GG2428@amd.com>
In-Reply-To: <20120411102136.GG2428@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 01:21 PM, Joerg Roedel wrote:
> Hi,
>
> On Wed, Apr 11, 2012 at 09:39:43AM +0800, zhangyanfei wrote:
> > The problem is that VMCS internal is hidden by Intel in its
> > specification. So, we reverse engineering it in the way implemented in
> > this patch set.
>
> Have you made sure this layout is the same on all uarchitectures that
> implment VMX?

He's determining the layout at runtime.  It should even work with kvm's
vmx implementation.

It's vulnerable to two issues:
- fields that are cached in the processor and not flushed to memory
(perhaps just make sure to VMXOFF before dumping memory)
- fields that are encoded differently in memory than VMREAD/VMWRITE

-- 
error compiling committee.c: too many arguments to function

