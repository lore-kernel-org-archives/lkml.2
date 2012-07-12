Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030618Ab2GLK7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:59:33 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34134 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030460Ab2GLK7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:59:32 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC 1/2] kvm vcpu: Note down pause loop exit
In-Reply-To: <4FFD5AED.3030307@linux.vnet.ibm.com>
References: <20120709062012.24030.37154.sendpatchset@codeblue> <20120709062032.24030.10454.sendpatchset@codeblue> <4FFD3F10.5020900@redhat.com> <4FFD5AED.3030307@linux.vnet.ibm.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Thu, 12 Jul 2012 16:28:59 +0530
Message-ID: <878vep4558.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12071210-9574-0000-0000-0000038B8B39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012 16:22:29 +0530, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
> On 07/11/2012 02:23 PM, Avi Kivity wrote:
> >
> > This adds some tiny overhead to vcpu entry.  You could remove it by
> > using the vcpu->requests mechanism to clear the flag, since
> > vcpu->requests is already checked on every entry.
> 
> So IIUC,  let's have request bit for indicating PLE,
> 
> pause_interception() /handle_pause()
> {
>   make_request(PLE_REQUEST)
>   vcpu_on_spin()
> 
> }
> 
> check_eligibility()
>   {
>   !test_request(PLE_REQUEST) || ( test_request(PLE_REQUEST)  && 
> dy_eligible())
> .
> .
> }
> 
> vcpu_run()
> {
> 
> check_request(PLE_REQUEST)
>
I know check_request will clear PLE_REQUEST, but you just need a
clear_request here, right?


