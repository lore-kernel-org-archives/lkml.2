Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab0GVGgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:36:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab0GVGgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:36:00 -0400
Message-ID: <4C47E7C9.60608@redhat.com>
Date: Thu, 22 Jul 2010 14:40:09 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [Patch] kexec: increase max of kexec segments and use dynamic
 allocation
References: <20100722061810.5659.87609.sendpatchset@localhost.localdomain> <m1wrso2foi.fsf@fess.ebiederm.org>
In-Reply-To: <m1wrso2foi.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/10 14:28, Eric W. Biederman wrote:
> Amerigo Wang<amwang@redhat.com>  writes:
>
>> Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine with
>> many memory ranges. Increase this hard limit to 1024 which is reasonably large,
>> and change ->segment from a static array to a dynamically allocated memory.
>
> ???
>
> This should be about segments in the executable being loaded.  What
> executable has one segment for each range of physical memory?
>
> Not that generalizing this is a bad idea but with a comment that
> seems entirely wrong I am wondering what the problem really is.
>

Ah, I think Neil should explain this.

He made a patch which includes many memory ranges, caused kexec
fails to load the kernel. Increasing this limit and the corresponding
one in kexec-tools fixes the problem. His patch is not in upstream
kexec-tools, AFAIK.

However, even if we don't consider that patch, isn't 16 too small too?

Thanks.

-- 
The opposite of love is not hate, it's indifference.
  - Elie Wiesel
