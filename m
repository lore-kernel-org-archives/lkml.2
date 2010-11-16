Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab0KPBQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:16:32 -0500
Received: from claw.goop.org ([74.207.240.146]:39362 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0KPBQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:16:31 -0500
Message-ID: <4CE1DB6E.9080301@goop.org>
Date: Mon, 15 Nov 2010 17:16:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 2/3] xen: add CPU microcode update driver
References: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>	<37a80bdde5957ffa81c2ecdffc4ccc2e874e34cb.1289519130.git.jeremy.fitzhardinge@citrix.com> <20101115155928.GC345@dumpdata.com>
In-Reply-To: <20101115155928.GC345@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 07:59 AM, Konrad Rzeszutek Wilk wrote:
>> +static enum ucode_state xen_request_microcode_user(int cpu,
>> +						   const void __user *buf, size_t size)
>> +{
>> +	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>> +	struct xen_microcode *uc;
>> +	enum ucode_state ret;
>> +	size_t unread;
>> +
>> +	if (cpu != 0) {
>> +		/* No real firmware for non-zero cpus; just store a
>> +		   placeholder */
>> +		size = 0;
>> +	}
>> +
>> +	if (uci->mc != NULL) {
>> +		vfree(uci->mc);
>> +		uci->mc = NULL;
>> +	}
>> +
>> +	ret = UCODE_ERROR;
>> +	uc = vmalloc(sizeof(*uc) + size);
>> +	if (uc == NULL)
>> +		goto out;
>> +
>> +	uc->len = size;
>> +
>> +	ret = UCODE_NFOUND;
>> +
>> +	/* XXX This sporadically returns uncopied bytes, so we return
>> +	   EFAULT.  As far as I can see, the usermode code
>            ^^^^^ UCODE_NFOUND.
>> +	   (microcode_ctl) isn't doing anything wrong... */
> Is this still valid? Looking at AMD it checks for a magic key and the Intel
> just copies without checks.

Probably not.

    J
