Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2LUX1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:27:24 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:39539 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2LUX1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:27:21 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "dzickus@redhat.com" <dzickus@redhat.com>
Subject: RE: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in
 non-blocking paths
Thread-Topic: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in
 non-blocking paths
Thread-Index: Ac3ewyNm+rP2IEnER5GHHHxmid334AATErOAADDDBKA=
Date: Fri, 21 Dec 2012 23:27:00 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2B22C@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A03B@USINDEM103.corp.hds.com>
 <20121220190923.GP88797@redhat.com>
In-Reply-To: <20121220190923.GP88797@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-21_08:2012-12-21,2012-12-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1212210257
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

Could you please apply this patchset to your tree?

Seiji

> -----Original Message-----
> From: Don Zickus [mailto:dzickus@redhat.com]
> Sent: Thursday, December 20, 2012 2:09 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; Luck, Tony (tony.luck@intel.com); ccross@android.com; keescook@chromium.org;
> cbouatmailru@gmail.com; Satoru Moriya; dle-develop@lists.sourceforge.net
> Subject: Re: [PATCH v3 0/2] pstore,efi_pstore: Avoid deadlock in non-blocking paths
> 
> On Thu, Dec 20, 2012 at 03:11:14PM +0000, Seiji Aguchi wrote:
> > Changelog
> > v2 -> v3
> >  - Merge modifications of pstore part in 2/2 to 1/2.
> >  - Rename pstore_is_non_blocking_path() to pstore_cannot_block_path().
> >
> > v1 -> v2
> >  - Erase a logic checking the number of online cpus.
> >  - Create a patchset to fix deadlocking issue in both pstore filesystem and
> >    efi_pstore driver.
> >    - Introduce a function, is_non_blocking_path(), to check if pstore
> >      is in panic and emergency-restart paths (PATCH 1/2)
> >    - Avoid efi_pstore_driver is blocked in non-blocking paths
> >      such as nmi, panic and emergency-restart paths (PATCH 2/2)
> >
> > [Issue]
> >
> > There are some paths in kernel which shouldn't be blocked, like NMI,
> > panic case after stopping cpus, emergency-restart.
> 
> I am ok with it.
> 
> Acked-by: Don Zickus <dzickus@redhat.com>
