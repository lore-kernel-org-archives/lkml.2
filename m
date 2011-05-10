Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab1EJQGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:06:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab1EJQGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:06:47 -0400
Subject: Re: [PATCH 3/3] perf, tools: Add support for guest/host-only
 profiling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <20110510154652.GF30996@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
	 <1305038132-5080-4-git-send-email-joerg.roedel@amd.com>
	 <1305039008.2914.98.camel@laptop> <20110510150821.GC30996@amd.com>
	 <1305041114.2914.105.camel@laptop>  <20110510154652.GF30996@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 18:09:46 +0200
Message-ID: <1305043786.2914.115.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 17:46 +0200, Roedel, Joerg wrote:
> 
> I intended to re-use the exlude_hv bit originally, but then I looked
> into how this bit is used. On PPC it looks like this bit is set when
> Linux itself runs as a guest to exclude the hypervisor code being
> profiled. The meaning here is different (beacause Linux itself is the
> hypervisor) and I wanted to avoid different semantics for this bit
> across architectures. So I introduces seperate bits.
> The exclude_hv bit can be used when we have some kind of perf-ctr
> support for KVM guests. 

Ah, I didn't mean it like that, yes HV is strictly something different
(and you understood its purpose well, its when the 'host' is a guest
itself). What I was wondering about is if we want HV to be included in
the Guest/Host exclusion mask or not.

Then again, I guess that'll change behaviour in non-obvious ways, so
better not do that.

