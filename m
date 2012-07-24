Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2GXRXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:23:39 -0400
Received: from usindpps03.hds.com ([207.126.252.16]:48710 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab2GXRXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:23:35 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
Subject: RE: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Topic: [RFC][PATCH v2 2/3] Hold multiple logs
Thread-Index: Ac1l82ceH7I0t1QCT1GombsnNxviZAAAK4PgAABTBVAAAP4IQAAA0SRAAAJWEXAAAc9d8AAOI+0AAK5hfwAAMAYhEA==
Date: Tue, 24 Jul 2012 17:23:18 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB33479@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA97@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
 <20120720030328.GC5637@redhat.com> <20120723141632.GB23047@srcf.ucam.org>
In-Reply-To: <20120723141632.GB23047@srcf.ucam.org>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-24_04:2012-07-24,2012-07-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207240155
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

I think all guys agree to hold multiple logs.
On the other hand, we have different opinions on overwriting policy.

So, I would like to find a way to fix this issue ,losing critical message, without overwriting policy at first.

I talked with Matthew a bit privately and he suggested to use QueryVariableInfo service which is supported in EFI 2.0 or later.
If we can use it, we know the remaining NVRAM space before calling SetVariable.

This mean that we can avoid the situation which efi_pstore have to handle out of space conditions.
Also, we don't need to introduce a new kernel parameter by just holding multiple logs.

What do you think?

Seiji

> -----Original Message-----
> From: Matthew Garrett [mailto:mjg@redhat.com]
> Sent: Monday, July 23, 2012 10:17 AM
> To: Don Zickus
> Cc: Seiji Aguchi; Luck, Tony; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org; mikew@google.com; dle-
> develop@lists.sourceforge.net; Satoru Moriya
> Subject: Re: [RFC][PATCH v2 2/3] Hold multiple logs
> 
> On Thu, Jul 19, 2012 at 11:03:28PM -0400, Don Zickus wrote:
> 
> > What is the harm of not using this and just letting the number be
> > infinite (or until EFI runs out of space)?  Is it a big deal if extra
> > failures are logged?
> 
> Running out of space in EFI isn't a well-tested scenario, and I wouldn't expect all firmware to handle it gracefully. This is made worse by
> EFI 1 not providing any information about available storage. I'd be fine with changing the default number of entries on systems where
> we can obtain the appropriate information to make that decision, but otherwise I think it should be limited to 1.
> 
> --
> Matthew Garrett | mjg59@srcf.ucam.org
