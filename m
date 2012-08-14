Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2HNSwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:52:17 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:47709 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab2HNSwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:52:16 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: efi_pstore: question about how to remove create_sysfs_entry()
 from a write callback.
Thread-Topic: efi_pstore: question about how to remove create_sysfs_entry()
 from a write callback.
Thread-Index: Ac16Npmt6jTfpP4+SGO2J5V3Hs4KkwAMhuYAAAddZ3A=
Date: Tue, 14 Aug 2012 18:51:59 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4137FC07B@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4137FBD89@USINDEM103.corp.hds.com>
 <CAGTjWtC2C_Q4mDHYD4p63YCkEAcYTgXcBYHemdTByrgBzNLT1A@mail.gmail.com>
In-Reply-To: <CAGTjWtC2C_Q4mDHYD4p63YCkEAcYTgXcBYHemdTByrgBzNLT1A@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-14_04:2012-08-14,2012-08-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208140184
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can we not serialize this with &efivars->lock if it is updated to disable interrupts?  A loop in the workqueue that locks, iterates through
> ->get_next_variable, and compares against searches in
> efivars->list should work, no?

If my understanding is correct, your pseudo code is as follows.

spin_lock_irqsave(&efivars_lock);

do {
	get_next_variable();
	if (found new entry)
 		efivars_create_sysfs_entries();

} while()

spin_lock_irqrestore(&efivars_lock);

But, memory is allocated dynamically with kzalloc() in efivars_create_sysfs_entries().
I don't want to allocate memory  while holding spin_lock.

Please let me know if I'm missing something.

Seiji 
