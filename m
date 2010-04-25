Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0DYIjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 04:39:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab0DYIjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 04:39:41 -0400
Message-ID: <4BD3FFC5.5030107@redhat.com>
Date: Sun, 25 Apr 2010 11:39:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] More fixes for nested svm
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 01:33 PM, Joerg Roedel wrote:
> Hi Avi, Marcelo,
>
> here is another set of nested svm fixes. They fix NMI code to make UP Hyper-V
> root domain booting. The patches also add better handling for nested entry
> failures and mce intercepts.
> Also in this patchset are the fixes for the supported cpuid reporting for svm
> features. These patches were taken from the nested-npt patchset and slightly
> modified. These patches are also marked for -stable backporting.
> The probably most important fix is about exception reinjection. This didn't
> work reliably before and is fixed with the patch in this series now. This fix
> also touches common x86 code but that should be ok because it could be reused
> by nested-vmx later.
> Please review and give comments (or apply ;-).
>
>    

All applied, thanks.

Regarding stable, it should be easy to backport the patches to 
2.6.34-rc6, but for 2.6.33 and earlier, it's murky.  And we certainly 
don't have the means to test them.

So please prepare _tested_ patchsets (git is fine) for 2.6.3[432].  I 
suggest you hold off for 2.6.3[32] until their next release, since there 
are a lot of kvm patches in review for them.  In general patches should 
be prepared against kvm.git kvm-updates/2.6.foo; we'll keep them up to 
date against stable.

Longer term, we need kvm-autotest support for nsvm, and unit tests in 
qemu-kvm/kvm/user/test.

-- 
error compiling committee.c: too many arguments to function

