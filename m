Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030612Ab2HWP6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:58:22 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:54850 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab2HWP6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:58:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,300,1344211200"; 
   d="scan'208";a="14151319"
Message-ID: <50364FE5.1070608@citrix.com>
Date: Thu, 23 Aug 2012 16:44:37 +0100
From: Attilio Rao <attilio.rao@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for x86_init.mapping.pagetable_reserve
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos>
In-Reply-To: <alpine.LFD.2.02.1208231722040.2856@ionos>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/12 16:46, Thomas Gleixner wrote:
> On Wed, 22 Aug 2012, Attilio Rao wrote:
>
>    
>> - Allow xen_mapping_pagetable_reserve() to handle a start different from
>>    pgt_buf_start, but still bigger than it.
>>      
> What's the purpose of this and how is this going to be used and how is
> it useful at all?
>    

(Just replying here as all the other your comments are derivative)
Looks like you are missing the whole point of the patch.
What the patch is supposed to do is just to "enforce a correct semantic 
for the setup function" and not fix an actual problem found in the code.
This means that after the patch you know exactly what expect in terms of 
semantic by the function and the callers will work following it.

Otherwise, what could happen is that if one day for a reason or another 
begin start being different from pgt_buf_start this function will just 
break silently, reintroducing the original problem in a different form.

I think this was clarified by the 0/2 but evidently you completely 
missed it.

Attilio
