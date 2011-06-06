Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1FFI2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:28:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab1FFI2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:28:12 -0400
Message-ID: <4DEC8F94.8010602@redhat.com>
Date: Mon, 06 Jun 2011 11:28:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, digitaleric@google.com,
        san@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH] KVM: Initialize kvm before registering the mmu notifier
References: <1307131493-553-1-git-send-email-mikew@google.com>
In-Reply-To: <1307131493-553-1-git-send-email-mikew@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2011 11:04 PM, Mike Waychison wrote:
> It doesn't make sense to ever see a half-initialized kvm structure on
> mmu notifier callbacks.  Previously, 85722cda changed the ordering to
> ensure that the mmu_lock was initialized before mmu notifier
> registration, but there is still a race where the mmu notifier could
> come in and try accessing other portions of struct kvm before they are
> intialized.
>
> Solve this by moving the mmu notifier registration to occur after the
> structure is completely initialized.

Thanks, applied, and queued for 3.0.

-- 
error compiling committee.c: too many arguments to function

