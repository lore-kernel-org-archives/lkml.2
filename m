Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0JZGgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:36:54 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53646 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0JZGgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:36:53 -0400
Message-ID: <4CC67776.809@oss.ntt.co.jp>
Date: Tue, 26 Oct 2010 15:38:46 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] kvm: write protect memory after slot swap
References: <20101025012124.GA31262@redhat.com> <4CC548C1.3060009@siemens.com> <20101025120545.GA17337@redhat.com>
In-Reply-To: <20101025120545.GA17337@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/25 21:05), Michael S. Tsirkin wrote:
> On Mon, Oct 25, 2010 at 11:07:13AM +0200, Jan Kiszka wrote:
>> Cool, seems to be the key to the corruptions I've seen. Applying your
>> patch make them disappear.
>
> Yes, works for me as well.
>

I did some tests on my laptop:
   - kvm.git + mst's patch
   - qemu.git (upstream qemu)
and still got graphics curruption.


Corruption:
   On usual Desktop environment, I opened two terminals on different
   workspaces. Then as Jan did, I did "find /" loop on both of them.

   During these heavy updates, I tried to switch between these
   workspaces some times. Then, at some turn, some part of old
   workspace's images like terminals and mouse cursor remained
   in the new workspace.

   I could refresh these by moving mouse over the problematic parts.
   But without doing so, the images remained still.


Refresh is not working on virtual machines as I expect?


Thanks,
   Takuya
