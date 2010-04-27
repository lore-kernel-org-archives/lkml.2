Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0D0SHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab0D0SHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:07:23 -0400
Message-ID: <4BD727D6.20609@redhat.com>
Date: Tue, 27 Apr 2010 21:07:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/6] Enable pvclock flags in vcpu_time_info structure
References: <1272303988-21929-1-git-send-email-glommer@redhat.com> <1272303988-21929-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1272303988-21929-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 08:46 PM, Glauber Costa wrote:
> This patch removes one padding byte and transform it into a flags
> field. New versions of guests using pvclock will query these flags
> upon each read.
>
> Flags, however, will only be interpreted when the guest decides to.
> It uses the pvclock_valid_flags function to signal that a specific
> set of flags should be taken into consideration. Which flags are valid
> are usually devised via HV negotiation.
>
>
> +void pvclock_valid_flags(u8 flags);
>    

set_pvclock_valid_flags() (or just set_pvclock_flags? 
pvclock_set_flags()?).  The original name looks like a getter.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

