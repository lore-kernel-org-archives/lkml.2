Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1KPSxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:53:07 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:50345 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1KPSxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:53:03 -0500
Message-ID: <4EC40682.2050602@linux.vnet.ibm.com>
Date: Wed, 16 Nov 2011 16:52:50 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org
Subject: Re: [PATCH 1/2] ima: split ima_add_digest_entry() function
References: <1321438229-18925-1-git-send-email-roberto.sassu@polito.it> <1321450690.1901.24.camel@falcor> <4EC3CA9A.3070401@polito.it>
In-Reply-To: <4EC3CA9A.3070401@polito.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11111618-9254-0000-0000-000007425B35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks, Rajiv Andrade Security Development IBM Linux Technology Center

On 16-11-2011 12:37, Roberto Sassu wrote:
> On 11/16/2011 02:38 PM, Mimi Zohar wrote:
>> On Wed, 2011-11-16 at 11:10 +0100, Roberto Sassu wrote:
>>> The ima_add_digest_entry() function has been split in order to avoid
>>> adding an entry in the measurements list for which the PCR extend
>>> operation subsequently fails. Required memory is allocated earlier 
>>> in the
>>> new function ima_prepare_template_entry() and the template entry is 
>>> added
>>> after ima_pcr_extend().
>>>
>>> Signed-off-by: Roberto Sassu<roberto.sassu@polito.it>
>>
>
> Hi Mimi
>
> i don't know if this condition can happen, but suppose that
> for whatever reason the PCR extend fails. In this case, since
> the PCR is not extended, the measurements list can be modified,
> by removing the non-measured entry, without this fact being
> detected by the verifier. So, probably we can avoid to display
> the entry.
>
>
Hi Roberto,

IMA's trustworthiness is built on the assumption that the TPM underneath can
be trusted. If that can't be, the eventlog alone doesn't provide us any 
security.
It's the TPM device driver's job though to workaround any HW bug so that 
in the
end all its stakeholders have their commands processed successfully, as 
we've
pursued in some changes here:

http://marc.info/?l=linux-kernel&m=132144742019589&w=2 
<http://marc.info/?l=linux-kernel&m=132144742019589&w=2>

What you're doing is to indeed move part of that trust to the software 
stack,
assuming that in case the TPM fails to process a command, you could fall 
back to
the event log anyways. It isn't a matter of it's a right or wrong 
software engineering
decision, but inside the trusted computing scope, it breaks the model.

Rajiv

