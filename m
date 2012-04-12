Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702Ab2DLUs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:48:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42973 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934676Ab2DLUs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:48:26 -0400
Message-ID: <4F873F7F.5080001@zytor.com>
Date: Thu, 12 Apr 2012 13:47:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com
Subject: Re: [PATCH V4 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
References: <4F87388C.300@zytor.com>  <4F87186B.9010303@zytor.com>  <cover.1331622735.git.rubini@gnudd.com> <5965c5b1f828732b3599131fb21070aba6f1a386.1331622735.git.rubini@gnudd.com> <20120314065614.GB27480@elte.hu> <20120412201533.GA26533@mail.gnudd.com> <20120412203220.GA27629@mail.gnudd.com>
In-Reply-To: <20120412203220.GA27629@mail.gnudd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 01:32 PM, Alessandro Rubini wrote:
>>
>> Not as a compile-time patch.
> 
> Why not? CONFIG_ISA is a compile-time choice. I thought that if you
> compile for non-ISA systems you may reuse the zone mechanism with a
> different split.
> 
> But if not a compile-time thing, would you accept it at run time?
> I feel it's not a beautiful approach, because it must clearly be
> masked by #ifndef CONFIG_ISA or such. Worse, you must know the zone
> split at the beginning, before you scan the PCI bus and find your
> devices.
> 

Compile-time is unacceptable, because it breaks the "one kernel image"
policy we have on x86.  So it should be done at runtime.

	-hpa

