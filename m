Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab2HTWIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 18:08:53 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:43810 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab2HTWIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 18:08:51 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Mike Waychison <mikew@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH v2 1/3] efivars: Disable external interrupt while
 holding efivars->lock
Thread-Topic: [RFC][PATCH v2 1/3] efivars: Disable external interrupt while
 holding efivars->lock
Thread-Index: AQHNfwhyC+DIWUp3g0mFikVdMA2/0ZdjQehQ
Date: Mon, 20 Aug 2012 22:08:35 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D413805F5B@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D413805C31@USINDEM103.corp.hds.com>
 <CAGTjWtAeL4AMWhWeiCrtXjumNSCjT1KTXd0KnH3_-4g_L91=Dw@mail.gmail.com>
In-Reply-To: <CAGTjWtAeL4AMWhWeiCrtXjumNSCjT1KTXd0KnH3_-4g_L91=Dw@mail.gmail.com>
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
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1208200279
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mike Waychison [mailto:mikew@google.com]
> Sent: Monday, August 20, 2012 3:17 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; Luck, Tony (tony.luck@intel.com); Matthew Garrett (mjg@redhat.com); dzickus@redhat.com; dle-
> develop@lists.sourceforge.net; Satoru Moriya
> Subject: Re: [RFC][PATCH v2 1/3] efivars: Disable external interrupt while holding efivars->lock
> 
> Acked-by: Mike Waychison <mikew@google.com>
> 
> > @@ -1101,11 +1107,12 @@ out_free:
> >  void unregister_efivars(struct efivars *efivars)  {
> >         struct efivar_entry *entry, *n;
> > +       unsigned long flags;
> >
> >         list_for_each_entry_safe(entry, n, &efivars->list, list) {
> > -               spin_lock(&efivars->lock);
> > +               spin_lock_irqsave(&efivars->lock, flags);
> >                 list_del(&entry->list);
> > -               spin_unlock(&efivars->lock);
> > +               spin_unlock_irqrestore(&efivars->lock, flags);
> >                 efivar_unregister(entry);
> >         }
> >         if (efivars->new_var)
> 
> Feel free to remove any other uses of flags where you know that you
> are being called from process context.

OK. I will remove the flags from unregister_efivars(), efivar_store_raw(), efivar_create() and efivar_delete().

If I'm missing something, please let me know.

Seiji


