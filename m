Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2DQK1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:27:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab2DQK1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:27:40 -0400
Message-ID: <4F8D4598.5080902@redhat.com>
Date: Tue, 17 Apr 2012 13:27:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Run PIT work in own kthread
References: <4F8C645C.7010302@siemens.com>
In-Reply-To: <4F8C645C.7010302@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 09:26 PM, Jan Kiszka wrote:
> We can't run PIT IRQ injection work in the interrupt context of the host
> timer. This would allow the user to influence the handler complexity by
> asking for a broadcast to a large number of VCPUs. Therefore, this work
> was pushed into workqueue context in 9d244caf2e. However, this prevents
> prioritizing the PIT injection over other task as workqueues share
> kernel threads.
>
> This replaces the workqueue with a kthread worker and gives that thread
> a name in the format "kvm-pit/<owner-process-pid>". That allows to
> identify and adjust the kthread priority according to the VM process
> parameters.

Is this a new ABI?

Patch looks reasonable.

-- 
error compiling committee.c: too many arguments to function

