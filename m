Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab0FGS2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:28:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48308 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0FGS2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:28:31 -0400
Message-ID: <4C0D39F2.7090806@oracle.com>
Date: Mon, 07 Jun 2010 11:26:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support kernel/hotplug sysctl variable when !CONFIG_NET
References: <1275911832-11667-1-git-send-email-abbotti@mev.co.uk> <20100607174350.GA7807@suse.de> <20100607111145.1b98fdb4.randy.dunlap@oracle.com> <20100607181651.GA9999@suse.de>
In-Reply-To: <20100607181651.GA9999@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4C0D3A49.0035:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/10 11:16, Greg KH wrote:
> On Mon, Jun 07, 2010 at 11:11:45AM -0700, Randy Dunlap wrote:
>> On Mon, 7 Jun 2010 10:43:50 -0700 Greg KH wrote:
>>
>>> On Mon, Jun 07, 2010 at 12:57:12PM +0100, Ian Abbott wrote:
>>>> From: Ian Abbott <abbotti@mev.co.uk>
>>>>
>>>> The kernel/hotplug sysctl variable (/proc/sys/kernel/hotplug file) was
>>>> made conditional on CONFIG_NET by commit
>>>> f743ca5e10f4145e0b3e6d11b9b46171e16af7ce (applied in 2.6.18) to fix
>>>> problems with undefined references in 2.6.16 when CONFIG_HOTPLUG=y &&
>>>> !CONFIG_NET, but this restriction is no longer needed.
>>
>> Ack, builds for me on x86_64 when CONFIG_NET is not enabled.
>>
>>> Why is this restriction no longer needed?  What changed?
>>
>>
>> commit cd3772e6898c6386f21d2958346d6dd57d4204f5
>> Author: Ming Lei <tom.leiming@gmail.com>
>> Date:   Sun Nov 16 18:22:09 2008 +0800
>>
>>     kernel/ksysfs.c:fix dependence on CONFIG_NET
>>     
>>     Access to uevent_seqnum and uevent_helper does not need to
>>     depend on CONFIG_NET, so remove it.
>>     
>>     Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>>     Cc: Kay Sievers <kay.sievers@vrfy.org>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> So something back in 2008 changed which requires a change now?

"requires" is too strong of a word to use here.  "allows" a change.

> I'm still confused, what use case calls for the original patch here
> being made?  Who wants to modify this option with CONFIG_NET disabled on
> their machine?


Are you trying to slow down on kernel patches for some reason?

Using CONFIG_NET is more restrictive than is needed here, so remove it.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
