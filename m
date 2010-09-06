Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0IFSht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:37:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab0IFShn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:37:43 -0400
Message-ID: <4C8534ED.7060302@redhat.com>
Date: Mon, 06 Sep 2010 21:37:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/27] Nested Paging Virtualization for KVM v3 (now with
 fixed Cc-List)
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 06:55 PM, Joerg Roedel wrote:
> (Now with correct Cc-list. I accidentially copied the wrong line from
>   MAINTAINERS in the first post of this. Sorry for the double-post)
>
> Hi Avi, Marcelo,
>
> here is finally the third round of my NPT virtualization patches for KVM. It
> took a while to get everything running (including KVM itself) on 32 bit again
> to actually test it. But testing on 32 bit host and with a 32 bit hypervisor
> was a very good idea. I found some serious bugs and shortcomings in my code
> that are fixed now in v3.
>

<snip>

> This patchset applies on todays avi/master + the three patches I sent end of
> last week. These patches are necessary for some of the tests above to run.
>
> For the curious and impatient user I put everything in a branch on kernel.org.
> If you want to test it you can pull the tree from
>
> 	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-kvm.git npt-virt-v3
>
> Please review and/or apply these patches if considered good enough. Otherwise I
> appreciate your feedback.

Very impressive patchset.  It's broken out so finely that the careful 
reader gets the feeling he understands every little detail, without 
noticing you've introduced recursion into the kvm mmu.

The little nit regarding patch 10 can be addressed in a follow-on patch.

Reviewed-by: Avi Kivity <avi@redhat.com>

Please also post a unit test that checks that nested page faults for l1 
ptes with bad NX, U, W, or reserved bits set are correctly intercepted 
and reported.  W should work already if you tested nested vga, but the 
rest are untested during normal operation and pose a security problem if 
they are incorrect.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

