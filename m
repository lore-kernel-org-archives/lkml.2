Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1GSIm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 04:42:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61474 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1GSImz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 04:42:55 -0400
Message-ID: <4E25442F.4080609@gmail.com>
Date: Tue, 19 Jul 2011 16:45:35 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, tony.luck@intel.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, dhowells@redhat.com, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW trackingof
 dirty & young
References: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFF@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8ADFF@saturn3.aculab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2011 04:26 PM, David Laight wrote:
>
>> Got it, if the fault_in_user_writeable() is designed to catch the
>> exact same write permission fault problem we discuss here, so
>> your patch fixed that very nicely, we should fixup it by directly
>> calling handle_mm_fault like what you did because we are for sure
>> to know what just happened(permission violation), its not necessary
>> to check what's happened by calling gup-->follow_page, and
>> further the follow_page failed to report the fault :-)
> One thought I've had - and I don't know enough about the data
> area in use to know if it is a problem - is what happens if
> a different cpu faults on the same user page and has already
> marked it 'valid' between the fault happening and the fault
> handler looking at the page tables to find out why.
> If any of the memory areas are shared, it might be that the
> PTE (etc) might already show the page a writable by the
> time the fault handler is looking at them - this might confuse it!
>

There is no problem at all if you mean *valid* by page present
and writable, because when the fault_in_user_writeable()
is called, the pte to the shared page was already setup by
demand paging and pte.present and pte.write was set, and the
reason why the fault was taken is that because of violation of
permission on present and writable user page occurred on sw
dirty/young tracking architectures.

Thanks
Shan Hai

> 	David
>
>

