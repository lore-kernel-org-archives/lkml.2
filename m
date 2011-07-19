Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab1GSTPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:15:11 -0400
Received: from usindmx02.hds.com ([207.126.252.13]:40949 "EHLO
	usindmx02.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1GSTPJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:15:09 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Matthew Garrett <mjg@redhat.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Tue, 19 Jul 2011 15:14:22 -0400
Subject: RE: [RFC][PATCH -mmotm 1/4] Add static function calls of pstore to
 kexec path
Thread-Topic: [RFC][PATCH -mmotm 1/4] Add static function calls of pstore to
 kexec path
Thread-Index: AcxGRPtCnItce4g8S62kXFPR9rxEzwAApICg
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64E5@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64C3@USINDEVS01.corp.hds.com>
 <20110719183506.GA23770@srcf.ucam.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C199C64D6@USINDEVS01.corp.hds.com>
 <20110719185213.GA24420@srcf.ucam.org>
In-Reply-To: <20110719185213.GA24420@srcf.ucam.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>And how does that handle the case where we're halfway through a pstore
>access when the NMI arrives? ERST, at least, has a complex state
>machine. You can't guarantee what starting one transaction without
>completing one that was in process will do.

As for ERST, write access is protected by raw_spin_trylock_irqsave(&erst_lock).
Are there anything I'm missing?

Seiji


>-----Original Message-----
>From: Matthew Garrett [mailto:mjg@redhat.com]
>Sent: Tuesday, July 19, 2011 2:52 PM
>To: Seiji Aguchi
>Cc: kexec@lists.infradead.org; linux-kernel@vger.kernel.org; linux-mtd@lists.infradead.org; Eric W. Biederman; Vivek
>Goyal; KOSAKI Motohiro; Americo Wang; tony.luck@intel.com; Andrew Morton; Jarod Wilson; hpa@zytor.com; dzickus@redhat.com;
>dle-develop@lists.sourceforge.net; Satoru Moriya
>Subject: Re: [RFC][PATCH -mmotm 1/4] Add static function calls of pstore to kexec path
>
>On Tue, Jul 19, 2011 at 02:48:22PM -0400, Seiji Aguchi wrote:
>> >How is this safe? What happens if there's a pstore access in process
>> >when you hit this codepath?
>>
>> This will never happen because pstore_kmsg_dump_in_interrupt() is called after machine_crash_shutdown().
>>
>> Panicked cpu sends NMI to all other cpus in machine_crash_shutdown() and they stop.
>
>And how does that handle the case where we're halfway through a pstore
>access when the NMI arrives? ERST, at least, has a complex state
>machine. You can't guarantee what starting one transaction without
>completing one that was in process will do.
>
>--
>Matthew Garrett | mjg59@srcf.ucam.org
