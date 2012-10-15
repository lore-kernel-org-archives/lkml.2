Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2JOPnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 11:43:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab2JOPnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 11:43:50 -0400
Message-ID: <507C2F18.8080904@redhat.com>
Date: Mon, 15 Oct 2012 17:43:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
CC: x86@kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] x86: clear vmcss on all cpus when doing kdump if
 necessary
References: <5077BB7B.4030203@cn.fujitsu.com>
In-Reply-To: <5077BB7B.4030203@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 08:40 AM, Zhang Yanfei wrote:
> Currently, kdump just makes all the logical processors leave VMX operation by
> executing VMXOFF instruction, so any VMCSs active on the logical processors may
> be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
> in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
> executing the VMXOFF instruction.

How have you verified that VMXOFF doesn't flush cached VMCSs already?

> 
> The patch set provides an alternative way to clear VMCSs related to guests
> on all cpus when host is doing kdump.
> 

I'm not sure the sysctl is really necessary.  The only reason to turn if
off is if the corruption is so severe that the loaded vmcs list itself
causes a crash.  I think it should be rare enough that we can do it
unconditionally.

-- 
error compiling committee.c: too many arguments to function
