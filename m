Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab1FUSWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:22:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57076 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab1FUSWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:22:51 -0400
References: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop> <1307470409-7654-1-git-send-email-stefano.stabellini@eu.citrix.com> <4DFFCBAD.9040507@linux.intel.com> <alpine.DEB.2.00.1106211601570.12963@kaball-desktop>
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.00.1106211601570.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] x86: calculate precisely the memory needed by init_memory_mapping
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 21 Jun 2011 11:02:43 -0700
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Message-ID: <18878791-c24a-4ca7-aa19-904805bc1314@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

>On Mon, 20 Jun 2011, H. Peter Anvin wrote:
>> On 06/07/2011 11:13 AM, stefano.stabellini@eu.citrix.com wrote:
>> > 
>> > - remove the extra page added on x86_32 for the fixmap because is
>not
>> > needed: the PMD entry is already allocated and contiguous for the
>whole
>> > range (a PMD page covers 4G of virtual addresses) and the pte entry
>is
>> > already allocated by early_ioremap_init.
>> > 
>> 
>> Hi Stefano,
>> 
>> I think this is wrong.  A PMD page covers *1G* of virtual addresses,
>and
>> in the 2+2 and 1+3 memory configurations, we may or may not need a
>> separate PMD for the fixmap.
>> 
>> Am I missing something?
>
>You are right, a PMD page covers 1G of virtual addresses so that part
>of
>the explanation in the comment is wrong.
>
>The reason why we don't need a separate PMD for the fixmap is that in
>both PAE and non-PAE cases the last gigabyte of virtual addresses is
>always covered by the initial allocation in head_32.S (swapper_pg_dir
>or
>initial_pg_pmd).

Ok, wasn't sure if Xen used the static allocation or not.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
