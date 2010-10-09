Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760433Ab0JISpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 14:45:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab0JISpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 14:45:15 -0400
Message-ID: <4CB0B803.3040008@redhat.com>
Date: Sat, 09 Oct 2010 20:44:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 07/12] Add async PF initialization to PV guest.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-8-git-send-email-gleb@redhat.com> <4CADC229.9040402@redhat.com> <20101008075414.GB8354@redhat.com>
In-Reply-To: <20101008075414.GB8354@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/08/2010 09:54 AM, Gleb Natapov wrote:
> >  >+
> >  >+static void kvm_guest_cpu_notify(void *dummy)
> >  >+{
> >  >+	if (!dummy)
> >  >+		kvm_guest_cpu_init();
> >  >+	else
> >  >+		kvm_pv_disable_apf(NULL);
> >  >+}
> >
> >  Why are you making decisions based on a dummy input?
> >
> >  The whole thing looks strange.  Use two functions?
> >
> What is so strange? Type of notification is passed as a parameter.
> The code that does this is just under the function. I can rename
> dummy to something else. Or make it two functions.

Two separate functions is simplest.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

