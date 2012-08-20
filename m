Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2HTV2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:28:24 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:42667 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab2HTV2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:28:22 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v2 3/3] efi_pstore: Skip scheduling a workqueue in
 cases other than oops
Thread-Topic: [RFC][PATCH v2 3/3] efi_pstore: Skip scheduling a workqueue in
 cases other than oops
Thread-Index: Ac1/CDDA4JvVCqvWQW2phkLrvnYE6AAKZmuAAAYu4tA=
Date: Mon, 20 Aug 2012 21:28:09 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413805E79@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C50@USINDEM103.corp.hds.com>
 <CAGTjWtBN0Ai_H0u6ACVbTCKgRXJU7Ln9nhjeb9wdOFQ0GQpP3w@mail.gmail.com>
In-Reply-To: <CAGTjWtBN0Ai_H0u6ACVbTCKgRXJU7Ln9nhjeb9wdOFQ0GQpP3w@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-20_04:2012-08-20,2012-08-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208200266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Also, a logic of erase callback is freshly created instead of sharing
> > with a write callback because the sysfs operation is kicked in just oops case in a write callback and an erase callback doesn't work
> without any change.
> > By separating a logic to a write callback, an erase callback works correctly.
> 
> I don't understand why this part of the patch is required.

If I have to keep sharing the code of an erase callback with a write callback,
I can change my patch as follows.

I just thought the code would be ieasy to read by separating them.

<snip>
efi_pstore_write()
{

 +       /*
 +        * The user may want to update when they erases an entry or see it for this write in sysfs in oops case.
 +        */
 +       if (!size || reason == KMSG_DUMP_OOPS)
 +               schedule_work(&efivar_work);

}
<snip>

Seiji

