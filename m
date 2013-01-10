Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3AJSXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:23:33 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:38255 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3AJSXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:23:32 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Tony Luck <tony.luck@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Subject: RE: [PATCH v3 1/2] pstore: Avoid deadlock in panic and
 emergency-restart path
Thread-Topic: [PATCH v3 1/2] pstore: Avoid deadlock in panic and
 emergency-restart path
Thread-Index: Ac3exFdBKrlqfcQKQf24y8a+iQwKcAQxM4YAAApyXpA=
Date: Thu, 10 Jan 2013 18:23:17 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3D392@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A05C@USINDEM103.corp.hds.com>
 <CA+8MBbKTHQJoeRVUGZr+rcXm+VwOw2vSG31Cwnrg-sc=CzLu9w@mail.gmail.com>
In-Reply-To: <CA+8MBbKTHQJoeRVUGZr+rcXm+VwOw2vSG31Cwnrg-sc=CzLu9w@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-10_09:2013-01-10,2013-01-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1301100147
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Acked-by: Tony Luck <tony.luck@intel.com>
> 
> [Also Ack for part2 the touches efivars.c]
> 

Thanks :)

> -Tony
> 
> [Or are you asking me to apply these rather than just Ack them??]

Please apply these to your tree.

Seiji

> -----Original Message-----
> From: Tony Luck [mailto:tony.luck@gmail.com]
> Sent: Thursday, January 10, 2013 1:21 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; dzickus@redhat.com; ccross@android.com; keescook@chromium.org; cbouatmailru@gmail.com;
> Satoru Moriya; dle-develop@lists.sourceforge.net
> Subject: Re: [PATCH v3 1/2] pstore: Avoid deadlock in panic and emergency-restart path
> 
> On Thu, Dec 20, 2012 at 7:12 AM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> > +       if (pstore_cannot_block_path(reason)) {
> > +               is_locked = spin_trylock_irqsave(&psinfo->buf_lock, flags);
> > +               if (!is_locked) {
> > +                       pr_err("pstore dump routine blocked in %s path, may corrupt error record\n"
> > +                                      , in_nmi() ? "NMI" : why);
> > +               }
> 
> My only quibble with this patchset is this message. The sentiment is nice, but nobody will see it. kmsg_dump has already picked the
> pieces of log_buf that will be saved to pstore - so this new message won't be included.  I suppose it will show up on a serial console -
> but if a user has a serial console, they don't need to use pstore.
> 
> But I don't think it is likely to hurt us (to get this far in a panic we already printed a bunch of stuff to the console and I can't think of a
> credible scenario where a few extra bytes would run into a problem that the earlier messages didn't).
> 
> So:
> 
> Acked-by: Tony Luck <tony.luck@intel.com>
> 
> [Also Ack for part2 the touches efivars.c]
> 
> -Tony
> 
> [Or are you asking me to apply these rather than just Ack them??]
