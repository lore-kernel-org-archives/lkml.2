Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0G1MZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:25:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702Ab0G1MZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:25:43 -0400
Message-ID: <4C5021C1.6030000@redhat.com>
Date: Wed, 28 Jul 2010 15:25:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: SVM: Emulate next_rip svm feature
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com> <1280247261-19115-3-git-send-email-joerg.roedel@amd.com> <4C4F2643.8080507@redhat.com> <20100728093708.GD26098@amd.com> <4C500636.1070708@redhat.com> <20100728112540.GE26098@amd.com> <4C5015B3.8010003@redhat.com> <20100728115133.GG26098@amd.com> <4C501B30.6020900@redhat.com> <20100728121822.GH26098@amd.com>
In-Reply-To: <20100728121822.GH26098@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/28/2010 03:18 PM, Roedel, Joerg wrote:
>
>
>> The guest (L2 in this case) is doomed since it execution cannot
>> continue.  But L1 and L0 are fine.  The problem with L2 avoiding
>> intercepts is that L2 can change control registers and take over L1.
> Right too. We can not ignore it. The right fix is probably a check for
> the instruction intercepts right after the decoder has run and before
> the emulator ran.

Should be easy - just like we have the Priv flag, add a bitfield to 
opcode_table that says which bit we need to check in the control area.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

