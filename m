Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0I3JoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:44:22 -0400
Received: from smtp.kponet.fi ([213.145.209.38]:52754 "EHLO smtp.kponet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab0I3JoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:44:21 -0400
Date: Thu, 30 Sep 2010 12:44:17 +0300
From: Sami Farin <hvtaifwkbgefbaei@gmail.com>
To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc: Sami Farin <hvtaifwkbgefbaei@gmail.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [E1000-devel] Something wrong with tx/rx/sg/gso with dhclient
 etc (Was: Linux 2.6.35.6/e1000e does not receive replies  from DHCP server,
 2.6.33 works)
Message-ID: <20100930094417.r6jgrljaer2opekv@m.safari.iki.fi>
Mail-Followup-To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
	Sami Farin <hvtaifwkbgefbaei@gmail.com>,
	linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
	netdev@vger.kernel.org
References: <20100927131935.d5f2ghpfaufiq6yx@m.safari.iki.fi>
 <20100927160731.ehcljyewa5b5wrbm@m.safari.iki.fi>
 <EA929A9653AAE14F841771FB1DE5A13660222E867B@rrsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A13660222E867B@rrsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 17:40:08 -0600, Tantilov, Emil S wrote:
> Sami Farin wrote:
> > False alarm, 2.6.35.6+latest git e1000e does not work any better.
> > I was just lucky.
> 
> Is your `latest git` from Linus or net-next tree? 

Linus.

>All of our latest patches go into net-next, so if you haven't already - give it a try and see if it resolves your issue.

Maybe later =)

> > 
> > One thing what was common, when it works, I get this line a little
> > time before dhclient start working:
> > 
> > eth0: IPv6 duplicate address fe80::219:d1ff:fe00:5f01 detected!
> 
> I have a system with the same device ID (it is not the same board) and could not reproduce any issues with DHCP on 2.6.35.6 kernel. 

Okay, thanks for trying.
 
> Aside from checking the latest net-next tree, there are some other things to look into:
> 
> 1. Is AMT enabled - there is usually a manageability tab/option in the BIOS. If you have that option try enabling/disabling it and see if it makes a difference.

I believe I haven't used AMT, but I check that option.

> 2. Make sure your BIOS is up to date.

Latest .ISO update which worked was CO6079P from Aug 2008, maybe I can
get the USB boot to work..

> If any of the above does not help your situation please file a bug at e1000.sf.net and include the following information:

I find it odd I stop seeing the reply packets just like that..
Can this be e1000e bug/feature or something else?
For example, I did "make oldconfig" in net-next, and:

----------------
CONFIG_NETFILTER_XT_TARGET_CHECKSUM:

This option adds a `CHECKSUM' target, which can be used in the iptables mangle table.

You can use this target to compute and fill in the checksum in
a packet that lacks a checksum.  This is particularly useful,
if you need to work around old applications such as dhcp clients,       <<=== here
that do not work well with checksum offloads, but don't want to disable
checksum offload in your device.
----------------

But not even tcpdump sees the packets..  shouldn't it see them despite
rx/tx settings?  What could be eating the packets?

FYI, I just played with "rx off tx off sg off gso off" and
"rx on tx on sg on gso on", when the options were all on, I could not
even get ARP reply from my router!  Two seconds after I turned them off,
all start working.  Also dhclient worked—now that I tried—with all off.
I believe there is something fishy in rx, tx, sg and/or gso features,
which worked in 2.6.33 AFAICT.  Am I sounding ambigue? ;)

> 1. lspci -vvv
> 2. ethtool -e eth0
> 3. there is a tool call ethregs which you can download from this site. If you can include the output of ethregs -s 00:19.0 
> 4. kernel config
> 5. anything that you think may be related - like setup, type of traffic etc.
> 
> Thanks,
> Emil

-- 
Do what you love because life is too short for anything else.

