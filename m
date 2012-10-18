Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2JRPCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:02:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45690 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab2JRPCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:02:51 -0400
Message-ID: <50801A14.5010003@zytor.com>
Date: Thu, 18 Oct 2012 08:02:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/4] xen/lowlevel: Implement pvop call for load_idt (sidt).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com> <1350481786-4969-3-git-send-email-konrad.wilk@oracle.com> <507F4475.80705@zytor.com> <20121018144538.GA19782@localhost.localdomain>
In-Reply-To: <20121018144538.GA19782@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 07:45 AM, Konrad Rzeszutek Wilk wrote:
>>
>> OK... this seems like another excellent set of pvops calls that
>> should be nukable to Kingdom Come.  There is no reason, ever, to
>> read the IDT and GDT from the kernel... the kernel already knows
>> what they should be!
>
> Even during suspend and resume cycle? There are the sequence of
> sidt/lidt calls being done there. And we do need to filter at
> least the sidt call - and in the case of ACPI suspend path,
> the lidt.

Yes, I am pretty sure we can make static guarantees on the IDT and GDTs.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

