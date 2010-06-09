Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0FIAOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 20:14:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:58830 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab0FIAOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 20:14:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,387,1272870000"; 
   d="scan'208";a="574551810"
From: "Wang, Qi" <qi.wang@intel.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
       "Clark, Joel" <joel.clark@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>, Arnd Bergmann <arnd@arndb.de>
Date: Wed, 9 Jun 2010 08:14:11 +0800
Subject: RE: [PATCH] Topcliff PHUB: Generate PacketHub driver
Thread-Topic: [PATCH] Topcliff PHUB: Generate PacketHub driver
Thread-Index: AcsG53ac7qRNSDm+RPChTH0J/05mBQAf/kCQ
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A1F204C55@shsmsx501.ccr.corp.intel.com>
References: <4C08D268.6000404@dsn.okisemi.com>
 <201006071537.27140.arnd@arndb.de>
 <002e01cb06e7$69846f10$66f8800a@maildom.okisemi.com>
In-Reply-To: <002e01cb06e7$69846f10$66f8800a@maildom.okisemi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohtake-san,

Let me explain what Arnd means.

Writing the all the registers with ioctl is discouraged. For this case, what you need is writing/updating or reading some registers, not all the registers of Topcliff. It's better that you implement as the following example.

For example, you want to update MAC register with 'aaaa'.
It's not a better way to pass the register of mac address and aaaa via the ioctl routine. It's better only pass the aaaa with the 'update mac address command' (update aaaa to mac register). Actually it's discouraged to pass the address information with ioctl routine, because it'll bring the security issue even if you check the address-range.

It's better to pass the command and relative argument to implement something, not 'the address', 'read/write register command' and 'the value to read/write'.

Any question, please let me know.

Best Regards,
Qi.

-----Original Message-----
From: Masayuki Ohtake [mailto:masa-korg@dsn.okisemi.com] 
Sent: Tuesday, June 08, 2010 4:49 PM
To: Arnd Bergmann
Cc: LKML; Khor, Andrew Chih Howe; Clark, Joel; Wang, Qi; Wang, Yong Y
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver

Hi Arnd

We are studying your indication.
> My feeling is that this ioctl interface is too
> low-level in general. You only export access to specific
> registers, not to functionality exposed by them.
> The best kernel interfaces are defined in a way that
> is independent of the underlying hardware and
> convert generic commands into device specific commands.

I have a question.
We don't know 'generic commands' concretely.
Let me know 'generic commands' in detail.

Thanks. Ohtake.

----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>; "Andrew" <andrew.chih.howe.khor@intel.com>; "Intel OTC"
<joel.clark@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y" <yong.y.wang@intel.com>
Sent: Monday, June 07, 2010 10:37 PM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> On Friday 04 June 2010, Masayuki Ohtake wrote:
> > From: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> >
> > This patch adds the Packet Hub driver for Topcliff.
> > Patch created against 2.6.33.1
> >
> > Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>
> Most of the comments from my first review still apply to
> this version, please have another look at what I wrote
> back in april, see http://article.gmane.org/gmane.linux.network/158879
>
> Note also that patch submissions should be against the latest
> development kernel, in this case 2.6.35-rc2, not against stable
> kernel releases like 2.6.33.1.
>
> Arnd
>


