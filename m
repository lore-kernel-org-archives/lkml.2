Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370Ab0JISdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:33:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab0JISdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:33:06 -0400
Message-ID: <4CB0B52E.90806@redhat.com>
Date: Sat, 09 Oct 2010 20:32:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 02/12] Halt vcpu if page it tries to access is swapped
 out.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-3-git-send-email-gleb@redhat.com> <4CAD97D0.70100@redhat.com> <20101007174716.GD2397@redhat.com> <4CB0B4BA.5010901@redhat.com>
In-Reply-To: <4CB0B4BA.5010901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/09/2010 08:30 PM, Avi Kivity wrote:
>> So that "info cpu" will interfere with apf? Migration should work
>> in regular way. apf state should not be migrated since it has no meaning
>> on the destination. I'll make sure synthetic halt state will not
>> interfere with migration.
>
>
> If you deliver an apf, the guest expects a completion.
>

btw, the token generation scheme resets as well.  Draining the queue 
fixes that as well.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

