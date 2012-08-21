Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2HUTYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:24:37 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:35285 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab2HUTYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:24:33 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v3 2/3] efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Topic: [RFC][PATCH v3 2/3] efi_pstore: Introducing workqueue updating
 sysfs entries
Thread-Index: Ac1/vZVDYYfkanc/Qlykdf5sw5DJBQAKtjUAAAWHeDA=
Date: Tue, 21 Aug 2012 19:24:09 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413806E4C@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413806C31@USINDEM103.corp.hds.com>
 <CAGTjWtA99e2n6ufCZfMOVTXiv1G01H-pP0VbcxqWma=soY9hHA@mail.gmail.com>
In-Reply-To: <CAGTjWtA99e2n6ufCZfMOVTXiv1G01H-pP0VbcxqWma=soY9hHA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-08-21_05:2012-08-21,2012-08-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208210194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  efivars_exit(void)
> >  {
> >         if (efi_enabled) {
> > +               cancel_work_sync(&efivar_work);
> 
> Please move this cancel_work_sync() to be before the efi_enabled test.
>  efi_enabled here means that we registered __efivars.  There may be another driver (gsmi) using the efivars code, so we should
> always be cancelling this work.
> 

OK. I will fix it.
I confirmed that gsmi accually called register_efivars().
Thank you for letting me know about this.

Seiji
