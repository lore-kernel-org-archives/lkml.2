Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0GWKdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:33:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab0GWKdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:33:05 -0400
Message-ID: <4C496FBA.3060009@redhat.com>
Date: Fri, 23 Jul 2010 12:32:26 +0200
From: Jan Safranek <jsafrane@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ivana Hutarova Varekova <varekova@redhat.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
References: <20100722182638.GA12712@kroah.com> <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com> <20100722183614.GA5443@suse.de> <20100722193741.GA2688@redhat.com> <20100722211856.GA1297@suse.de> <AANLkTinFQtwrCC82T9KlKskDV8fn-zYgimyH2wguHkqY@mail.gmail.com> <20100722231401.GA11538@suse.de> <20100723020714.GA11236@redhat.com>
In-Reply-To: <20100723020714.GA11236@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 04:07 AM, Vivek Goyal wrote:
> On Thu, Jul 22, 2010 at 04:14:01PM -0700, Greg KH wrote:
>> On Fri, Jul 23, 2010 at 01:08:12AM +0200, Kay Sievers wrote:
>>> On Thu, Jul 22, 2010 at 23:18, Greg KH<gregkh@suse.de>  wrote:
>>>>> For my testing I now always use /cgroup/ and create directories under it
>>>>> /cgroup/blkio /cgroup/cpu etc and mount controllers on respective
>>>>> directories.
>>>>
>>>> Lennart and Kay, is this what systemd is doing?  I really don't think we
>>>> should be adding a root /cgroup/ mount point to the system for something
>>>> like this.
>>>
>>> Already solved. Systemd always mounts an empty tmpfs at the 'cgroup'
>>> mountpoint, and stuff is free to create subdirs there. Systemd itself
>>> mount 'systemd' there.
>>
>> Ah, that makes it easier.  Paul and Vivek, any objection to this patch
>> going in now?
>>
>
> This sounds reasonable to me also.
>
> Jan, I know you have been working in this area and raised concenrs about
> cgroup mount point in the past. Does it look good to you?

I would prefer some place where subdirectories can be created for 
individual hierarchies without additional tmpfs there. But as I 
understand /sys, it's not an easy feature to implement it there, so no, 
I am not against /sys/fs/cgroup.

Jan
