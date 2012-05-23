Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab2EWIhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2EWIhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:37:46 -0400
Message-ID: <4FBCA1D6.1070905@redhat.com>
Date: Wed, 23 May 2012 11:37:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: qemu core dump and filtering guest pages
References: <4FBBFFB5.3010605@de.ibm.com>
In-Reply-To: <4FBBFFB5.3010605@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 12:05 AM, Christian Borntraeger wrote:
> Folks,
> 
> today we discussed the situation of a qemu crash (with coredump) and big guests.
> Quite often the guest pages are not needed but make the core file pretty big.
> 
> The most appealing proposal that we had was to adopt the core file code in the 
> kernel to have an option for discarding guest pages (e.g. /proc/sys/core_guest).
> do_corefile would have a callback into the kvm module that could use its memory 
> slot infrastructure to decide if this page should be saved or not.
> 
> Would you consider such a change be ok? Any better idea?


There's MADV_DONTDUMP which can be used to control this on a per-guest
basis.


-- 
error compiling committee.c: too many arguments to function
