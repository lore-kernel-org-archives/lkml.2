Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2GYMNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:13:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529Ab2GYMNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:13:38 -0400
Date: Wed, 25 Jul 2012 14:13:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/11] perf kvm: guest userspace samples should not be
 lumped with host uspace
Message-ID: <20120725121330.GD946@krava.brq.redhat.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-4-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342826756-64663-4-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 05:25:48PM -0600, David Ahern wrote:
> e.g., perf kvm --host  --guest report -i perf.data --stdio -D
> shows:
> 
> 1 599127912065356 0x143b8 [0x48]: PERF_RECORD_SAMPLE(IP, 5): 5671/5676: 0x7fdf95a061c0 period: 1 addr: 0
> ... chain: nr:2
> .....  0: ffffffffffffff80
> .....  1: fffffffffffffe00
>  ... thread: qemu-kvm:5671
>  ...... dso: <not found>
> 
> (IP, 5) means sample in guest userspace. Those samples should not be lumped
> into the VMM's host thread. i.e, the report output:
> 
>     56.86%  qemu-kvm  [unknown]         [u] 0x00007fdf95a061c0
> 
> With this patch the output emphasizes it is a guest userspace hit:
> 
>     56.86%  [guest/5671]  [unknown]         [u] 0x00007fdf95a061c0
> 
> Looking at 3 VMs (2 64-bit, 1 32-bit) with each running a CPU bound
> process (openssl speed), perf report currently shows:
> 
>   93.84%  117726   qemu-kvm  [unknown]   [u] 0x00007fd7dcaea8e5
> 
> which is wrong. With this patch you get:
> 
>   31.50%   39258   [guest/18772]  [unknown]   [u] 0x00007fd7dcaea8e5
>   31.50%   39236   [guest/11230]  [unknown]   [u] 0x0000000000a57340
>   30.84%   39232   [guest/18395]  [unknown]   [u] 0x00007f66f641e107

Tested-by: Jiri Olsa <jolsa@redhat.com>
