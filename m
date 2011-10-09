Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab1JINhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 09:37:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1JINhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 09:37:52 -0400
Message-ID: <4E91A3AA.1000309@redhat.com>
Date: Sun, 09 Oct 2011 15:37:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] KVM: x86: optimize for writing guest page
References: <4E7AF758.7060900@cn.fujitsu.com> <20111006175333.GA3959@amt.cnet> <4E8FCC37.8090409@cn.fujitsu.com> <4E91926D.8060206@redhat.com>
In-Reply-To: <4E91926D.8060206@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2011 02:24 PM, Avi Kivity wrote:
> On 10/08/2011 06:06 AM, Xiao Guangrong wrote:
>> On 10/07/2011 01:53 AM, Marcelo Tosatti wrote:
>> >  On Thu, Sep 22, 2011 at 04:52:40PM +0800, Xiao Guangrong wrote:
>> >>  This patchset is against https://github.com/avikivity/kvm.git 
>> next branch.
>> >>
>> >>  In this version, some changes come from Avi's comments:
>> >>  - fix instruction retried for nested guest
>> >>  - skip write-flooding for the sp whose level is 1
>> >>  - rename some functions
>> >
>> >  Please rebase.
>> >
>> >
>>
>> Marcelo,
>>
>> These patches can be applied without any conflict and it also works 
>> well,
>> the current code was pulled from https://github.com/avikivity/kvm.git 
>> next branch.
>>
>> What problem did you meet when you applied these? :(
>
> I guess it was a user error - it applies cleanly here too (and pushed 
> to next, thanks).
>

However, it seems to reduce performance.

Autotest results before:

Test                                        Status     Seconds  Info
----                                        ------     -------  ----
         (Result file: ../../results/default/status)
unittest                                    GOOD       147      
completed successfully
Fedora.9.32.install.smp2                    GOOD       865      
completed successfully
Fedora.9.32.boot.smp2                       GOOD       46       
completed successfully
Fedora.9.32.reboot.smp2                     GOOD       49       
completed successfully
Fedora.9.32.shutdown.smp2                   GOOD       15       
completed successfully
Fedora.9.64.install.smp2                    GOOD       943      
completed successfully
Fedora.9.64.boot.smp2                       GOOD       47       
completed successfully
Fedora.9.64.reboot.smp2                     GOOD       48       
completed successfully
Fedora.9.64.shutdown.smp2                   GOOD       14       
completed successfully
WinXP.32.install.smp2                       GOOD       772      
completed successfully
WinXP.32.setup.smp2                         GOOD       53       
completed successfully
WinXP.32.boot.smp2                          GOOD       57       
completed successfully
WinXP.32.reboot.smp2                        GOOD       34       
completed successfully
WinXP.32.shutdown.smp2                      GOOD       5        
completed successfully
WinXP.64.install.smp2                       GOOD       636      
completed successfully


After:

unittest                                    GOOD       150      
completed successfully
Fedora.9.32.install.smp2                    GOOD       879      
completed successfully
Fedora.9.32.boot.smp2                       GOOD       50       
completed successfully
Fedora.9.32.reboot.smp2                     GOOD       48       
completed successfully
Fedora.9.32.shutdown.smp2                   GOOD       15       
completed successfully
Fedora.9.64.install.smp2                    GOOD       997      
completed successfully
Fedora.9.64.boot.smp2                       GOOD       47       
completed successfully
Fedora.9.64.reboot.smp2                     GOOD       48       
completed successfully
Fedora.9.64.shutdown.smp2                   GOOD       14       
completed successfully
WinXP.32.install.smp2                       GOOD       764      
completed successfully
WinXP.32.setup.smp2                         GOOD       51       
completed successfully
WinXP.32.boot.smp2                          GOOD       40       
completed successfully
WinXP.32.reboot.smp2                        GOOD       34       
completed successfully
WinXP.32.shutdown.smp2                      GOOD       5        
completed successfully
WinXP.64.install.smp2                       GOOD       666      
completed successfully


-- 
error compiling committee.c: too many arguments to function

