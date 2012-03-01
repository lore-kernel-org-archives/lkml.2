Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab2CACYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 21:24:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43438 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161Ab2CACYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 21:24:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F4EDD9A.4050900@jp.fujitsu.com>
Date: Thu, 01 Mar 2012 11:23:22 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org> <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab> <4F4E145E.4040901@redhat.com> <20120229121914.GD21224@aftab> <4F4E22B1.6020505@redhat.com> <20120229133741.GF21224@aftab>
In-Reply-To: <20120229133741.GF21224@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/29 22:37), Borislav Petkov wrote:
> On Wed, Feb 29, 2012 at 10:05:53AM -0300, Mauro Carvalho Chehab wrote:
>> Em 29-02-2012 09:19, Borislav Petkov escreveu:
>> - on SB, the MCE status register only has the error message. In order to get
>>   the DIMM location, the driver needs to parse the registers that describe
>>   how the DIMM's are organized (this is spread on dozens of PCI devices, and
>>   200+ registers), and how they're interlaced, in order to convert the error 
>>   address reported by the MCA into a DIMM location.
> 
> As I already said, amd64_edac does a similar thing does already so I
> don't see any difference in the solutions there: decode to the DIMM and
> pass the info through 'msg'.

My concern is; on Sandy Bridge, is it safe to gather info about the DIMM
location in/from machine check context in a reasonable time span?
I know that for corrected errors which is handled in normal context it is
safe to refer the vast PCI configuration space...

Or is it really possible to determine the erroneous DIMM location from OS?
It looks like that how to get the location is highly depending on the
hardware, processor's vendor/family/model and firmware configuration etc..
Even if OS tells me "please replace memory seated on slot#3 at node#5" or
so, I'm not sure whether these numbers are consistent over reboot if
there are some hot-plugged node and/or memory.  Order of numbering can
be changed by how firmware enumerate ACPI namespace or so...
Actually in these days we usually use firmware's system event log to
determine which module should be replaced, assuming that firmware knows
hardware better than OSes running on that machine.

Getting back to the "msg" I think it is not necessary if it does not
contain any new data which is not available in the mce_record today.
If you just want to add field about physical memory location, I think
string "msg" is not only way to do so.


Thanks,
H.Seto

