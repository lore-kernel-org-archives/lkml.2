Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2DSMBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:01:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38861 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab2DSMBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:01:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 19 Apr 2012 21:01:19 +0900 (JST)
Message-Id: <20120419.210119.246504497.d.hatayama@jp.fujitsu.com>
To: avi@redhat.com
Cc: zhangyanfei@cn.fujitsu.com, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, joerg.roedel@amd.com, dzickus@redhat.com,
        paul.gortmaker@windriver.com, gregkh@suse.de, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4F8FF7AC.1060309@redhat.com>
References: <4F8FEC22.400@redhat.com>
	<20120419.202707.276752866.d.hatayama@jp.fujitsu.com>
	<4F8FF7AC.1060309@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information for kdump
Date: Thu, 19 Apr 2012 14:31:56 +0300

> On 04/19/2012 02:27 PM, HATAYAMA Daisuke wrote:
>> >> The reason why we want to retrieve guest machine's memory image as
>> >> crash dump is that then we can debug guest machine's status using
>> >> symbolic debugger such as gdb and crash utility.
>> >>
>> >> This is very useful. Please consider the situation where engineers are
>> >> forced to look into guest machine's memory image through qemu-kvm's
>> >> process core dump using gdb without any symbolic information. It's
>> >> very inefficient.
>> > 
>> > I still don't follow.  If qemu crashed, the values in guest registers
>> > are irrelevant.  In what way can the help debug the qemu crash?
>> > 
>>
>> It would be not helpful for the qemu crash case you are concerned
>> about. We want to use the guest state data to look into guest
>> machine's image in the crasshed qemu.
> 
> Why?
> 

It seems natural to check the situation from guest machine's side when
qemu crashs. Suppose a service is running on the guest machine, and
then the qemu crash. Then, we may need to know the details of the
progress of the service if it's important. What has been successfully
done, and what has not yet.

Thanks.
HATAYAMA, Daisuke

