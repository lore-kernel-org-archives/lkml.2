Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab0GWMJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:09:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:33179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab0GWMJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:09:33 -0400
Date: Fri, 23 Jul 2010 05:06:55 -0700
From: Greg KH <gregkh@suse.de>
To: Jan Safranek <jsafrane@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
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
Message-ID: <20100723120655.GB32608@suse.de>
References: <20100722182638.GA12712@kroah.com> <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com> <20100722183614.GA5443@suse.de> <20100722193741.GA2688@redhat.com> <20100722211856.GA1297@suse.de> <AANLkTinFQtwrCC82T9KlKskDV8fn-zYgimyH2wguHkqY@mail.gmail.com> <20100722231401.GA11538@suse.de> <20100723020714.GA11236@redhat.com> <4C496FBA.3060009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C496FBA.3060009@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 12:32:26PM +0200, Jan Safranek wrote:
> On 07/23/2010 04:07 AM, Vivek Goyal wrote:
>> On Thu, Jul 22, 2010 at 04:14:01PM -0700, Greg KH wrote:
>>> On Fri, Jul 23, 2010 at 01:08:12AM +0200, Kay Sievers wrote:
>>>> On Thu, Jul 22, 2010 at 23:18, Greg KH<gregkh@suse.de>  wrote:
>>>>>> For my testing I now always use /cgroup/ and create directories under it
>>>>>> /cgroup/blkio /cgroup/cpu etc and mount controllers on respective
>>>>>> directories.
>>>>>
>>>>> Lennart and Kay, is this what systemd is doing?  I really don't think we
>>>>> should be adding a root /cgroup/ mount point to the system for something
>>>>> like this.
>>>>
>>>> Already solved. Systemd always mounts an empty tmpfs at the 'cgroup'
>>>> mountpoint, and stuff is free to create subdirs there. Systemd itself
>>>> mount 'systemd' there.
>>>
>>> Ah, that makes it easier.  Paul and Vivek, any objection to this patch
>>> going in now?
>>>
>>
>> This sounds reasonable to me also.
>>
>> Jan, I know you have been working in this area and raised concenrs about
>> cgroup mount point in the past. Does it look good to you?
>
> I would prefer some place where subdirectories can be created for 
> individual hierarchies without additional tmpfs there. But as I understand 
> /sys, it's not an easy feature to implement it there, so no, I am not 
> against /sys/fs/cgroup.

Great, thanks for letting us know.

So, who can get this patch into mainline?

thanks,

greg k-h
