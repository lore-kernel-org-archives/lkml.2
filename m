Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab0GVHIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 03:08:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33032 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab0GVHIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 03:08:10 -0400
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [Patch] kexec: increase max of kexec segments and use dynamic allocation
References: <20100722061810.5659.87609.sendpatchset@localhost.localdomain>
	<m1wrso2foi.fsf@fess.ebiederm.org> <4C47E7C9.60608@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 22 Jul 2010 00:08:05 -0700
In-Reply-To: <4C47E7C9.60608@redhat.com> (Cong Wang's message of "Thu\, 22 Jul 2010 14\:40\:09 +0800")
Message-ID: <m1iq482duy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <amwang@redhat.com> writes:

> On 07/22/10 14:28, Eric W. Biederman wrote:
>> Amerigo Wang<amwang@redhat.com>  writes:
>>
>>> Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine with
>>> many memory ranges. Increase this hard limit to 1024 which is reasonably large,
>>> and change ->segment from a static array to a dynamically allocated memory.
>>
>> ???
>>
>> This should be about segments in the executable being loaded.  What
>> executable has one segment for each range of physical memory?
>>
>> Not that generalizing this is a bad idea but with a comment that
>> seems entirely wrong I am wondering what the problem really is.
>>
>
> Ah, I think Neil should explain this.
>
> He made a patch which includes many memory ranges, caused kexec
> fails to load the kernel. Increasing this limit and the corresponding
> one in kexec-tools fixes the problem. His patch is not in upstream
> kexec-tools, AFAIK.
>
> However, even if we don't consider that patch, isn't 16 too small too?

Generally you just need one physical hunk for the code, maybe a second
for the initrd.

It is perfectly fine to raise the number of segments as it doesn't
affect the ABI, but it wants a good explanation of what kind of weird
application wants to write to all over memory when it is loaded.

Eric
