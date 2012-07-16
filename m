Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab2GPSF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:05:27 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:20995 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753231Ab2GPSFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:05:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Y.Xd9XAVM1l1N9bw4x4iCCCtMh4f0ziftEtaCYIy2.UIcIe
 fKl1.AyYdqemcVQeP8SvLvnPSlvTcD6mVbaT1QL5pYdEYmtd7icmMeejIY3L
 pg0samzj_zh.HxvX0mcRjypMYsJ.UZqCMhInGQcI8fG2o4PImb0qXP8zelJD
 9gokPBp564YtaSbbQHCvD5tdLazg48tqCRMqFXTz43xw1X3IhMOeuV2RTEbc
 VEandyHiKItqbS0TX9JFsb8RJXRuzaQvndotU3dYkiDGu816yZnlh6VSamxe
 SgrKW3IoraWk7gQR491bsH5HZP_xzv.PK_Ayy.nXfuS7DoiZdM6IrfycK9hI
 AoVdy1LgY_kvha0cd35iVFAMLogZglGcvZ32q3FJ2mONCT7A90A5YzcN9wvr
 03SeZGY0TAP4BnJBCyzKAip92tPz0uTE6rdiM
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 16 Jul 2012 13:05:22 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: Michal Nazarewicz <mina86@tlen.pl>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: correct return value of migrate_pages()
In-Reply-To: <CAAmzW4OS7=xfm0shxsi0k8kJ=2oNs4MQAEJ=EJv_xRydrukF1w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207161302560.32319@router.home>
References: <1342455272-32703-1-git-send-email-js1304@gmail.com> <874np7r4ee.fsf@erwin.mina86.com> <CAAmzW4OS7=xfm0shxsi0k8kJ=2oNs4MQAEJ=EJv_xRydrukF1w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, JoonSoo Kim wrote:

> > Actually, it makes me wonder if there is any code that uses this
> > information.  If not, it would be best in my opinion to make it return
> > zero or negative error code, but that would have to be checked.
>
> I think that, too.
> I looked at every callsites for migrate_pages() and there is no place
> which really need fail count.
> This function sometimes makes caller error-prone,
> so I think changing return value is preferable.
>
> How do you think, Christoph?

We could do that. I am not aware of anything using that information
either. However, the condition in which some pages where migrated and
others are not is not like a classic error. In many situations the moving
of the pages is done for performance reasons. This just means that the
best performant memory locations could not be used for some pages. A
situation like that may be ok for an application.

