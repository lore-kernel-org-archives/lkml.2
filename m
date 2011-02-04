Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1BDVDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:03:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab1BDVDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:03:10 -0500
Message-ID: <4D4C698A.4010201@redhat.com>
Date: Fri, 04 Feb 2011 16:03:06 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Convert tsc_write_lock to raw_spinlock
References: <4D4BCB97.6000900@siemens.com>
In-Reply-To: <4D4BCB97.6000900@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 04:49 AM, Jan Kiszka wrote:
> Code under this lock requires non-preemptibility. Ensure this also over
> -rt by converting it to raw spinlock.
>    

Oh dear, I had forgotten about that.  I believe kvm_lock might have the 
same assumption in a few places regarding clock.
