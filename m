Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0DWFmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:42:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48071 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab0DWFmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:42:35 -0400
To: Cong Wang <amwang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Haren Myneni <hbabu@us.ibm.com>, Neil Horman <nhorman@tuxdriver.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/5] Add second memory region for crash kernel
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
	<m1aasvkupc.fsf@fess.ebiederm.org> <20100422224525.GJ3228@redhat.com>
	<m1eii7j8ne.fsf@fess.ebiederm.org> <4BD12E48.3080400@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 22 Apr 2010 22:42:25 -0700
In-Reply-To: <4BD12E48.3080400@redhat.com> (Cong Wang's message of "Fri\, 23 Apr 2010 13\:21\:12 +0800")
Message-ID: <m1zl0uiv26.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, kexec@lists.infradead.org, nhorman@tuxdriver.com, hbabu@us.ibm.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, v.mayatskih@gmail.com, vgoyal@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <amwang@redhat.com> writes:

> Eric W. Biederman wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>>
>>> Vitaly, have you really run into cases where 2G upper limit is a concern.
>>> What is the configuration you have, how much memory it has and how much
>>> memory are you planning to reserve for kdump kernel?
>>
>> A good question.
>>
>
> We have observed that on a machine which has 66G memory, when we do
> crashkernel=1G@4G, kexec failed to load the crash kernel, but the memory
> reservation _did_ succeed.

Did you try loading vmlinux?   If not this sounds like the fact that
/sbin/kexec doesn't realize it can boot a 64bit bzImage in 64bit
mode.

Eric

