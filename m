Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1K0KhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:37:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1K0KhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:37:03 -0500
Message-ID: <4ED212C7.1080901@redhat.com>
Date: Sun, 27 Nov 2011 12:36:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Liu Ping Fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        aliguori@us.ibm.com, jan.kiszka@web.de, ryanh@us.ibm.com
Subject: Re: [PATCH 2/2] kvm: exit to userspace with reason KVM_EXIT_VCPU_DEAD
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com> <1322361735-21428-1-git-send-email-kernelfans@gmail.com>
In-Reply-To: <1322361735-21428-1-git-send-email-kernelfans@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2011 04:42 AM, Liu Ping Fan wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>
> The vcpu can be safely released when
> --1.guest tells us that the vcpu is not needed any longer.
> --2.vcpu hits the last instruction _halt_
>
> If both of the conditions are satisfied, kvm exits to userspace
> with the reason vcpu dead. So the user thread can exit safely.
>
>

Seems to be completely unnecessary.  If you want to exit from the vcpu
thread, send it a signal.

-- 
error compiling committee.c: too many arguments to function

