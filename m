Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab1CWXR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:17:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61096 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114Ab1CWXRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:x-face:face:x-url:x-pgp-fp:x-pgp:date
         :in-reply-to:message-id:user-agent:mime-version:content-type;
        b=W8n4YL9WpjIZIhqeuL7yCJ3GAM+mAH64lLo1rnbLn3OMyDWv/OvvNAfL2oQtc/x5zt
         oAK0xrkcnS78hhOQesnWtmXBV2kzr3VTjkSrpVUlIigiVqOJ/9NmtKCRcTpEbn2K0w3q
         jmpqFGzzRGZzCAhnKmPYNpBDIdYuF2ImvEloE=
From: Michal Nazarewicz <mnazarewicz@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        =?utf-8?Q?Micha=C5=82?= Nazarewicz <mnazarewicz@gmail.com>,
        broonie@opensource.wolfsonmicro.com,
        lkml <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, grant.likely@secretlab.ca,
        Linux USB list <linux-usb@vger.kernel.org>, andy.green@linaro.org,
        netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        roger.quadros@nokia.com, Jaswinder Singh <jaswinder.singh@linaro.org>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
References: <4D79F068.2080009@linaro.org> <201103232035.18232.arnd@arndb.de>
	<AANLkTim7hPfTv3gDYnh+jGxHBg0OvX=r1FKYoHnH7H_o@mail.gmail.com>
	<201103232057.18150.arnd@arndb.de>
	<20110323125958.76285c0f.rdunlap@xenotime.net>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Thu, 24 Mar 2011 00:17:34 +0100
In-Reply-To: <20110323125958.76285c0f.rdunlap@xenotime.net> (Randy Dunlap's
	message of "Wed, 23 Mar 2011 12:59:58 -0700")
Message-ID: <8762r9l94h.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>>>>>> @@ -97,6 +97,8 @@ struct driver_info {
>>>>>>
>>>>>>  #define FLAG_LINK_INTR       0x0800          /* updates link (carri=
er) status */
>>>>>>
>>>>>> +#define FLAG_PTP     0x1000          /* maybe use "usb%d" names */

>>>> On Wednesday 23 March 2011 19:46:50 Greg KH wrote:
>>>>> "PTP"?  What does that stand for?

>>> On Mar 23, 2011 8:36 PM, "Arnd Bergmann" <arnd@arndb.de> wrote:
>>>> point-to-point, I'll improve the comment to spell it out when
>>>> I send the fixed version.

>> On Wednesday 23 March 2011 20:53:13 Micha=C5=82 Nazarewicz wrote:
>>> I think P2P could be better.

> On Wed, 23 Mar 2011 20:57:18 +0100 Arnd Bergmann wrote:
>> Yes, good idea.

Randy Dunlap <rdunlap@xenotime.net> writes:
> that's peer-to-peer.
>
> OTOH, I knew that PTP was point-to-point.

It can be any of that, depending on context.  For me PTP is more like
Picture Transport Protocol, whereas "2" between two letters is usually
"to".

Just my two cents though, no strong feelings or anything.

=2D-=20
Best regards,                                          _     _
 .o. | Liege of Serenly Enlightened Majesty of       o' \,=3D./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
 ooo +-<mina86-mina86.com>-<jid:mina86-jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk2Kf5UACgkQUyzLALfG3x601wCgpGmM9j0n6j/U8nARWZ90rhM7
pR0AoIvKT6gfV54cBg3c6eB2RQI0rOzw
=1sLy
-----END PGP SIGNATURE-----
--=-=-=--
