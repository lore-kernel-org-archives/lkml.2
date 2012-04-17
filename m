Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2DQLSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:18:38 -0400
Received: from goliath.siemens.de ([192.35.17.28]:29709 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab2DQLSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:18:35 -0400
Message-ID: <4F8D5186.7020801@siemens.com>
Date: Tue, 17 Apr 2012 13:18:30 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Run PIT work in own kthread
References: <4F8C645C.7010302@siemens.com> <4F8D4598.5080902@redhat.com>
In-Reply-To: <4F8D4598.5080902@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-17 12:27, Avi Kivity wrote:
> On 04/16/2012 09:26 PM, Jan Kiszka wrote:
>> We can't run PIT IRQ injection work in the interrupt context of the host
>> timer. This would allow the user to influence the handler complexity by
>> asking for a broadcast to a large number of VCPUs. Therefore, this work
>> was pushed into workqueue context in 9d244caf2e. However, this prevents
>> prioritizing the PIT injection over other task as workqueues share
>> kernel threads.
>>
>> This replaces the workqueue with a kthread worker and gives that thread
>> a name in the format "kvm-pit/<owner-process-pid>". That allows to
>> identify and adjust the kthread priority according to the VM process
>> parameters.
> 
> Is this a new ABI?

Yep. Scripts will use it, maybe even QEMU. Do you want this to appear in
api.txt?

> 
> Patch looks reasonable.
> 

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
