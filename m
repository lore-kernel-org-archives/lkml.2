Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2HNVic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:38:32 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:59052 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2HNVib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:38:31 -0400
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
Thread-Index: Ac16Npmt6jTfpP4+SGO2J5V3Hs4KkwAMhuYAAAddZ3AADOaFoP//i5WAgAA2n/A=
Date: Tue, 14 Aug 2012 21:38:20 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4137FC29E@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4137FBD89@USINDEM103.corp.hds.com>
 <CAGTjWtC2C_Q4mDHYD4p63YCkEAcYTgXcBYHemdTByrgBzNLT1A@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D4137FC07B@USINDEM103.corp.hds.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D4137FC0DF@USINDEM103.corp.hds.com>
 <CAGTjWtCrE3v+q0nKtM-Nx5PKDQ6CVGjU=uF0Gp=W97u9bHAjgg@mail.gmail.com>
In-Reply-To: <CAGTjWtCrE3v+q0nKtM-Nx5PKDQ6CVGjU=uF0Gp=W97u9bHAjgg@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-14_06:2012-08-14,2012-08-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208140226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Something like this (pseudo) may work:
> 
> /* Loop until we have all entries in efivars. */ while (1) {
>   variable_name = kzalloc(1024, GFP_KERNEL );
>   spin_lock_irqsave(&efivars->lock);
>   bool found = false;
>   while (1) {
>      ret = ops->get_next_variable(variable_name)
>      if (ret == EFI_NOT_FOUND)
>         break;
>      if (!variable_is_already_present(variable, &efivars->list) {
>        found = true;
>        break;
>      }
>   }
>   if (!found) {
>     kfree(variable_name);
>     break;
>   }
>   <Register in sysfs>
> }
> 

Thanks. It seems to work.
I will create a patch based on your pseudo code above.

> 
> If we are calling into pstore_info ops though from interrupt context, it seems we'll need to fix the immediate problem of updating the
> locking throughout to be interrupt safe.
> 

I agree with you. It should be fixing.  I will update the locking to be interrupt safe as well.

Seiji
