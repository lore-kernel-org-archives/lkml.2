Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1DSRMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:12:53 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:20400 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753748Ab1DSRMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:12:52 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: MC6zFsoVM1nuYFvVZBLsMaKtlnVCJi8NHufuC.8wx3dJv3Q
 eQfvJrH3H6W7DCMoep5Eos3fhX774hHWTfm0ju6Od5wdsW03nC2P8j6VJqCu
 gxCJ4DDMvCsuQ4Pt6Z7scnlalsihPzmz4I2qjQbiNJnMPfJxfMSYzryge1o5
 sZxMewDhXlhzxrnwdJizpMXgGBpm0Q3RY2Z_Nhj1juY3EM.4hhepqp833y3U
 FAXJc9Fljvfi6KKvzsx.cn..cS1cFXwAOMg63hjeM_o0Vf.PWz9naHZuU4.J
 NMlzjhpK7USvtjZLU._iGYRkng1Ng7o9xXSIXuUbpkoswhz_F
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 19 Apr 2011 12:12:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <BANLkTimYrD_Sby_u-fPSwn-RJJyEVavU5w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1104191211480.17888@router.home>
References: <20110415135144.GE8828@tiehlicka.suse.cz> <alpine.LSU.2.00.1104171952040.22679@sister.anvils> <20110418100131.GD8925@tiehlicka.suse.cz> <20110418135637.5baac204.akpm@linux-foundation.org> <20110419111004.GE21689@tiehlicka.suse.cz>
 <1303228009.3171.18.camel@mulgrave.site> <BANLkTimYrD_Sby_u-fPSwn-RJJyEVavU5w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-755122748-1303233170=:17888"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-755122748-1303233170=:17888
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 19 Apr 2011, Pekka Enberg wrote:

> On Tue, Apr 19, 2011 at 6:46 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > It compiles OK, but crashes on boot in fsck. =A0The crash is definitely=
 mm
> > but looks to be a slab problem (it's a null deref on a spinlock in
> > add_partial(), which seems unrelated to this patch).

That means that the per node structures have not been setup yet. Node
hotplug not working?

> > It seems to be a random intermittent mm crash because the next reboot
> > crashed with the same trace but after the fsck had completed and the
> > third came up to the login prompt.
>
> Looks like a genuine SLUB problem on parisc. Christoph?

Race between node hotplug and use of the slab on that node?

---1463811839-755122748-1303233170=:17888--
