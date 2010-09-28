Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635Ab0I1Drk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 23:47:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50295 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059Ab0I1Drj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 23:47:39 -0400
Message-ID: <4CA16522.8060107@zytor.com>
Date: Mon, 27 Sep 2010 20:46:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, caiqian@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4CA11918.7050708@kernel.org> <4CA11FB7.2080101@zytor.com> <4CA126BE.7000609@kernel.org> <4CA1283C.9010105@zytor.com> <4CA12976.5060504@kernel.org> <4CA129EB.5000309@zytor.com> <4CA12BAB.1040308@kernel.org> <20100928005358.GA6456@redhat.com>
In-Reply-To: <20100928005358.GA6456@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 05:53 PM, Vivek Goyal wrote:
> 
> Actually, hardcoding the upper limit to 4G is probably not the best idea.
> Kexec loads the the relocatable binary (purgatory) and I remember that
> one of the generated relocation type was signed 32 bit and allowed max value
> to be 2G only. So IIRC, purgatory code always needed to be loaded below 2G.
> 
> I liked HPA's other idea better of introducing memblock_find_in_range_lowest() 
> so that we search bottom up and not rely on a specific upper limit.
> 

No, it's just another crappy hack which is broken in the same way.  It's
better than open-coding, but it's still a hack.

The Right Thing[TM] to do is for kexec to communicate the topmost
address it wants to this code, so it has both the upper and the lower
boundaries available to it instead of just one.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

