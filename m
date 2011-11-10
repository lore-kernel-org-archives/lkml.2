Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab1KJALu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:11:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36780 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846Ab1KJALt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:11:49 -0500
Message-ID: <4EBB16BE.9050308@zytor.com>
Date: Wed, 09 Nov 2011 16:11:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrei Warkentin <awarkentin@vmware.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: /dev/mem "unbounded?"
References: <1927751307.356328.1320878326756.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1927751307.356328.1320878326756.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 02:38 PM, Andrei Warkentin wrote:
> Hi Peter,
> 
> ----- Original Message -----
>>
>> That would be incorrect behavior, though, except perhaps for the
>> range
>> that cannot be addressed by the processor.  It is explicitly
>> permitted
>> to address ranges that does not have addresses mapped to it.
> 
> There is a current mechanism for restricting access to a subset
> of addresses, and it is used to enforce < 1MB accesses on x86
> if CONFIG_STRICT_DEVMEM. This could be extended.
> 

Well, that mechanism is broken.  The way it *should* work is that any
region which is system RAM should be denied access, and the rest is
accessible.  The current behavior is a hack due to the behavior of some
old versions of Xorg, but that has long been fixed.

> Do you think there is any value in specifying something like
> CONFIG_DEV_MEM_ONLY_CLAIMED, which would only allow accesses
> until the end of the last range claimed with request_region (but
> could, of course, well be unmapped). This will allow accesses to
> any unclaimed "holes" in between. I.e., if you have 0-100m claimed,
> followed by 300-700m claimed, then reading /dev/mem will work up
> until you reach 700m.

No.  If you don't know what you're accessing, you should not be touching
/dev/mem under any circumstances.  Odds are that even if you're only
reading, there are registers with side effects in there somewhere.

	-hpa



