Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1LOLzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 06:55:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab1LOLzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 06:55:35 -0500
Message-ID: <4EE9E023.4000904@redhat.com>
Date: Thu, 15 Dec 2011 13:55:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
CC: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped
 by host
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net> <20111208113422.GA27919@amit-x200.redhat.com>
In-Reply-To: <20111208113422.GA27919@amit-x200.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 01:34 PM, Amit Shah wrote:
> On (Mon) 05 Dec 2011 [15:18:59], Eric B Munson wrote:
> > When a guest kernel is stopped by the host hypervisor it can look like a soft
> > lockup to the guest kernel.  This false warning can mask later soft lockup
> > warnings which may be real.  This patch series adds a method for a host
> > hypervisor to communicate to a guest kernel that it is being stopped.  The
> > final patch in the series has the watchdog check this flag when it goes to
> > issue a soft lockup warning and skip the warning if the guest knows it was
> > stopped.
>
> Guest S4 would need similar treatment, and I think the code in the two
> approaches can be shared.  Just something to consider.
>

Why does S4 need any treatment?  The guest is aware that it's sleeping,
unlike the other cases treated here.

-- 
error compiling committee.c: too many arguments to function

