Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1BCVXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:23:36 -0500
Received: from server19320154104.serverpool.info ([193.201.54.104]:43228 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab1BCVXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:23:35 -0500
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Feb 2011 16:23:34 EST
Message-ID: <4D4B1AF4.2050000@hauke-m.de>
Date: Thu, 03 Feb 2011 22:15:32 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        "Zhao, Shanyu" <shanyu.zhao@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Lance Zimmerman <lance.zimmerman@atheros.com>,
        Prem Kumar <Prem.Kumar@atheros.com>
Subject: Re: Backporting other subsystems on Linux
References: <380B2771CDD78E46856E6B788D9F1997D2468080@orsmsx503.amr.corp.intel.com> <BD672EAEE3AD2C47A7120B0973C3FB3A50F0AC156A@SC1EXMB-MBCL.global.atheros.com> <380B2771CDD78E46856E6B788D9F1997D27D86D2@orsmsx503.amr.corp.intel.com> <20110202220926.GB3035@tux> <20110202222645.GE3035@tux>
In-Reply-To: <20110202222645.GE3035@tux>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 11:26 PM, Luis R. Rodriguez wrote:
> On Wed, Feb 02, 2011 at 02:09:26PM -0800, Luis Rodriguez wrote:
>> Increasing audience.
>>
>> On Wed, Feb 02, 2011 at 01:27:10PM -0800, Zhao, Shanyu wrote:
>>> Hi Luis,
>>>
>>> Thank you for the quick response. When I say USB, I didn't mean USB network
>>> drivers, I'm talking about USB host/device controller drivers or gadget
>>> drivers. For example, we can backport USB3 support to, say, 2.6.28.
>>>
>>> From what I understand, I can add any driver to your compat-wireless tree and
>>> build it the same way as other wireless drivers. Am I right?
>>
>> That's right.
>>
>>> Then your tree should really be called compat-drivers. :) I'm not sure if
>>> you're welcoming non-network related drivers.

When adding more and more stuff we should probably rename
compat-wireless to something else. ;-)
I am fine with adding USB3 support, if Intel will help maintaining the
stuff in compat-wireless after they added it.

>> What I really need to get to at some point is to use implement a
>> menuconfig thingy, we already drag the Kconfigs in but use config.mk for
>> makefile/dependency mapping. Patches welcomed.
> 
> BTW one idea I have as of recent is to consider using Hudson for automatic
> build testing for compat-wireless but haven't yet mucked with it. Eventually
> this will be more and more important as time goes by and we support older
> kernels. The goal is to at the *very least* always support down to the last
> stable 2.6 kernel listed on kernel.org, today that is 2.6.27 and I think its
> a safe promise to commit to backporting *at least* to that kernel. We go
> beyond 2.6.27 though today.

Automatic compile testing is really needed for compat-wireless. There
are often some special kernel version where it does not compile, like
now. ;-)

Some time ago I started writing a small bash script which tries to build
compat-wireless for various kernel versions and sends a email if
something went wrong. This was more or less hacked together from the
compat-wireless release script and some other scripts I have here. I
stopped working on this after I recognized that my server is way to slow
for running this script (compat-wireless build for one kernel toke more
than 30 minutes).

Using hudson or buildbot [2] is the better choice, but it should just
take 1 to 2 hours to get this hacked script working. Luis do you have a
server with hudson installed or a server capable for running hudson and
building compat-wireless? My server has a Intel Celeron with 2.4 GHz and
512MB Ram. I have to clean up my script before releasing it to someone
else, but if someone is interest I have no problem with making it relay
for use.

[1] http://en.wikipedia.org/wiki/Hudson_(software)
[2] http://en.wikipedia.org/wiki/BuildBot

Hauke
