Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1HDSqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 14:46:53 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39984 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab1HDSqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 14:46:47 -0400
Message-ID: <4E3AE912.7050402@us.ibm.com>
Date: Thu, 04 Aug 2011 13:46:42 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: dlaor@redhat.com
CC: Eric B Munson <emunson@mgebm.net>, kvm@vger.kernel.org,
        kvm-ia64@vger.kernel.org, kvm-ppc@vger.kernel.org, avi@redhat.com,
        riel@redhat.com, glommer@redhat.com, linux-kernel@vger.kernel.org,
        Ryan A Harper <raharper@us.ibm.com>, Glauber Costa <glommer@gmail.com>
Subject: Re: [RFC PATCH 0/3] Avoid soft lockup message when KVM is stopped
 by host
References: <1312381501-27746-1-git-send-email-emunson@mgebm.net> <4E3A5A38.9080406@redhat.com>
In-Reply-To: <4E3A5A38.9080406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 03:37 AM, Dor Laor wrote:
> On 08/03/2011 05:24 PM, Eric B Munson wrote:
>> This set is just a rough first pass at avoiding soft lockup warnings
>> when a host
>> pauses the execution of a guest. A flag is set by the host in the
>> shared page
>> used for the pvclock when the host goes to stop the guest. When the guest
>> resumes and detects a soft lockup, this flag is checked and cleared
>> and the soft
>> lockup message is skipped.
>
> While this will cover the case were the host stops a guest, there will
> be other plain cases where the host is just over committed and will
> cause a softlockup false positive on the guest.
>
> Softlockup should use stolen time that makes use of the guest running
> info would cover both cases

At least in the current steal time implementation, there are numerous 
cases where steal time is not accounted but you'd hit a soft lockup.

Pausing an idle guest via (qemu) stop is an example.  Likewise, a guest 
that is descheduled while idle but then not scheduled for prolonged 
periods of time would also not be accounted as steal time.

Regards,

Anthony Liguori
