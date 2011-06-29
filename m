Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1F2Hz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 03:55:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57220 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1F2HzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 03:55:21 -0400
Message-ID: <4E0ADA66.9070004@canonical.com>
Date: Wed, 29 Jun 2011 08:55:18 +0100
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/2] AppArmor: Fix masking of capabilities in complain
 mode
References: <1309311874-23262-1-git-send-email-john.johansen@canonical.com> <1309311874-23262-3-git-send-email-john.johansen@canonical.com> <20110629042440.GC18344@kroah.com>
In-Reply-To: <20110629042440.GC18344@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 05:24 AM, Greg KH wrote:
> On Wed, Jun 29, 2011 at 02:44:34AM +0100, John Johansen wrote:
>> AppArmor is masking the capabilities returned by capget against the
>> capabilities mask in the profile.  This is wrong, in complain mode the
>> profile has effectively all capabilities, as the profile restrictions are
>> not being enforced, merely tested against to determine if an access is
>> known by the profile.
>>
>> This can result in the wrong behavior of security conscience applications
>> like sshd which examine their capability set, and change their behavior
>> accordingly.  In this case because of the masked capability set being
>> returned sshd fails due to DAC checks, even when the profile is in complain
>> mode.
>>
>> Kernels affected: 2.6.36 - 3.0.
>>
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
>> ---
> 
> You say that multiple kernels are affected, then why not also include
> stable@kernel.org here as well?
> 
> confused,
> 
Sorry I should have elaborated, I think its a borderline case for stable
release, and was as much a note to my self as anything.

The bug doesn't affect the enforcement of policy, only learning mode used
for generating policy, and it is something we can work around in userspace.
for already released kernels.

I can resend with a Cc: stable if you would like



