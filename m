Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0JNVhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:37:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab0JNVho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:37:44 -0400
Message-ID: <4CB7781D.80103@suse.cz>
Date: Thu, 14 Oct 2010 23:37:33 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: jeffrey.t.kirsher@intel.com, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        e1000-devel <e1000-devel@lists.sourceforge.net>
Subject: Re: [RFC PATCH net-next] drivers/net Documentation/networking: Create
 directory intel_wired_lan
References: <1286743352.11039.165.camel@Joe-Laptop>	 <AANLkTikVKufQRuMGd=cdig7ff4k2aw9Q1FWwMz3pgon-@mail.gmail.com>	 <1286841648.26045.17.camel@Joe-Laptop>	 <1287008906.1117.428.camel@Joe-Laptop>	 <1287032255.4113.14.camel@jtkirshe-MOBL1>	 <1287035857.1117.528.camel@Joe-Laptop>	 <1287048849.3319.20.camel@jtkirshe-MOBL1> <1287084643.1117.602.camel@Joe-Laptop>
In-Reply-To: <1287084643.1117.602.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.10.2010 21:30, Joe Perches wrote:
> On Thu, 2010-10-14 at 02:34 -0700, Jeff Kirsher wrote:
>> On Wed, 2010-10-13 at 22:57 -0700, Joe Perches wrote:
>>> On Wed, 2010-10-13 at 21:57 -0700, Jeff Kirsher wrote:
>>>> On Wed, 2010-10-13 at 15:28 -0700, Joe Perches wrote:
>>>> Sorry I am not ignoring you, I was taking a closer look at your patch.
>>>>> What regression testing would actually be done?
>>>> The Makefile and Kconfig needs more work.  I applied your patch and none
>>>> of the Intel Wired drivers build.
>>> Care to describe the Makefile/Kconfig issues you have seen?
>>> I built it allyesconfig, defconfig, allmodconfig and allnoconfig.
>> Yeah, I found all of those built without errors, but if you build the
>> Intel Wired LAN drivers as modules, you will not find the *.ko files
>> after the build.  The Kconfig files look fine, the problem was with the
>> Makefiles.  Instead of creating a drivers/net/intel_wired_lan/Makefile,
>> I simply changed the path in drivers/net/Makefile to the updated path
>> and that resolved the issue.
> 
> (adding a few cc's and a link for history)
> 
> http://lkml.org/lkml/2010/10/10/207
> 
> That's the way I had done it originally as well, but I found
> you couldn't build the directory with:
> 
> 	make drivers/net/intel_wired_lan/
> 
> so I created a Makefile in the new directory below with
> the elements necessary.
> 
> Perhaps there's some missing functionality in the build system
> when the Kconfig file resides in a higher directory and the
> directory being built doesn't have a Kconfig file?

This has nothing to do with Kconfig files, I assume you meant Makefiles.


> I think it'd wrong to duplicate the makefile components in
> 2 places to allow "make subdir/" and I wonder if there's a
> good solution for this.

There is no duplication needed, drivers/net/Makefile needs to contain
obj-y += intel_wired_lan/ and drivers/net/intel_wired_lan/Makefile
similar lines for its subdirs. I see your original patch was lacking an
entry in drivers/net/Makefile, so perhaps that was the problem Jeff was
seeing?

Michal
