Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab2JYVi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:38:27 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:40576 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2JYViY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:38:24 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from
 a write callback to hold multiple logs
Thread-Topic: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from
 a write callback to hold multiple logs
Thread-Index: Ac2yU45Umwbisi8ERWqdMazeX7tkNwAs24eAAAdb8lD//9btAIAAP3Sw///QzoCAAEAzEA==
Date: Thu, 25 Oct 2012 21:37:50 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138899AF@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD@USINDEM103.corp.hds.com>
 <CAGTjWtDVZGq7VKou10xC-zJXGmane_kKjGo1xMjgPUkKAedFqQ@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D413889851@USINDEM103.corp.hds.com>
 <CAGTjWtAUv=HzOGPDeDuTb_6z81bnSQ-F7DDERZ2tqmfaP4wXwQ@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D413889905@USINDEM103.corp.hds.com>
 <CAGTjWtDEQx8mCKtNTGGSOMajAoSCJTaKWG8TBmYinQMPfx5DQQ@mail.gmail.com>
In-Reply-To: <CAGTjWtDEQx8mCKtNTGGSOMajAoSCJTaKWG8TBmYinQMPfx5DQQ@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-25_04:2012-10-25,2012-10-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1210250280
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On the other hand, patch 5/5 changes the format by adding sequence counter.
> > But efi_pstore_read is modied to work correctly in it.
> >
> >         dump-type0-1-1-1351113059-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
> >
> >         Variable Name: dump-type0-1-1-1351113059
> >         GUID: cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
> >
> > If I need to elaborate more, please feel free to ask me:) I'm not sure
> > if I understand your question completely.
> 
> In this case, I think efi_pstore_read in patch 5/5 should probably fall-back to trying to do a sscanf(...) == 3 if the sscanf(...) == 4 test fails
> so that dumps for older dumps from previous kernels are still visible to users, no?  They can perhaps get a default count of 0?
> efi_pstore_erase would have to be updated to understand this as well.

OK. I understand your concern.
I will update my patch to work with an old format too.
In addition to efi_pstore_read(), efi_pstore_erase should be modified.

Anyway, I will post a patch v3 later.

Thank you for reviewing.

Seiji
