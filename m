Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2BBMlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:41:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2BBMlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:41:00 -0500
Message-ID: <4F2A844B.107@redhat.com>
Date: Thu, 02 Feb 2012 14:40:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: n2CpHSJnr4MP@dyweni.com
CC: KVM <kvm@vger.kernel.org>, Qemu Devel <qemu-devel@nongnu.org>,
        Oprofile-List <oprofile-list@lists.sourceforge.net>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: general protection fault
References: <3c9160646ba439b51b505543c0ac8275@pl1.haspere.com>
In-Reply-To: <3c9160646ba439b51b505543c0ac8275@pl1.haspere.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 06:40 AM, Dyweni - KVM wrote:
> Hi All,
>
> I'm not sure who this falls to, so I've included all all parties that
> I thought may be relevant.
>
> I'm getting the following error from my guest kernel when running
> oprofile within qemu-kvm:
>

kvm does not virtualize a PMU before Linux 3.3, so oprofile is not
supported.  The facilities for identifying the PMU to the guest are very
lacking, so it's hard to make this fail gracefully.

On a Linux 3.3 host, you can provide a PMU to the guest, but only using
latest qemu and providing -cpu host or similar.  This only works on
Intel hosts for now.

-- 
error compiling committee.c: too many arguments to function

