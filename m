Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab2LDNIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:08:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54214 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2LDNIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:08:04 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-keystone@list.ti.com,
        Cyril Chemparathy <cyril@ti.com>
Subject: Re: [linux-keystone] [PATCH v2] drivers: cma: fix addressing on PAE machines
In-Reply-To: <50BD9C45.7070501@ti.com>
Organization: http://mina86.com/
References: <1354549570-21445-1-git-send-email-vitalya@ti.com> <50BD9C45.7070501@ti.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 04 Dec 2012 14:07:53 +0100
Message-ID: <xa1tsj7m3qza.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Monday 03 December 2012 09:16 PM, Vitaly Andrianov wrote:
>> This patch fixes a couple of bugs that otherwise impair CMA functionalit=
y on
>> PAE machines:
>>
>>    - alignment must be a 64-bit type when running on systems with 64-bit
>>      physical addresses.  If this is not the case, the limit calculation=
 thunks
>>      allocations down to an address range < 4G.
>>
>>    - The allocated range check is removed. On 32bit ARM kernel with LPAE
>>      enabled the base may be allocated outside the fist 4GB of physical
>>      memory (keystone SoC for example).

On Tue, Dec 04 2012, Santosh Shilimkar wrote:
> Any reason you have clubbed two fixes in one patch. Its better to keep
> the two fixes separate patches.

They are all related to the very same issue, and what the whole patch
does is change the type used to store physical addresses from unsigned
long to phys_addr_t.  This is really a single change.

>> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
>> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQvfWpAAoJECBgQBJQdR/0r/8P/2APcdinX1PdoI8McwE+7pDO
VZJS3kefGGc4KH6KgbtHiXsmpctTWtBHb0dBOTpU/YsAUt0RKMKX0871cWZOQS1l
U6TESUESvYDA/Se1UVEgZbSakVRX5npRECeyqUttG9/xg/WDQdbnDs8WPvxbmrlX
krTTL3e6Mtwi3AdzD3xNu7j5v21YfDn7QFkKibEMUuQLsNbTdknt+MYyMlXv/MOJ
4NpaJV84byjyiN+3rJNbVElYo3FfbX1ko9p+z7wBUv+76n8avBuzZbkv3Em63QuC
B2uEm6SLYtttyMLArOzqTnwdaf67b5oocM5wYywIzNeg3cbSU5jhBqiKTQNTlSOZ
QTz9tmNku2GFhCHzvZHiztjvuLrRXhtRjycgj0IJyOeYMehnCF6Fqh4x+8Wcquv8
aguOBRK2GFpu3T9EfWc/axGmUn+kajdTnwVwiMUeC5MPIxmJnGC4Mzr/o8w+1K3P
nAdWNY6GTtZhXQ9XeT8RQXvoAndvNwNtCL0M90yAD1aOBCz+IAqGnDOQEZ8WzsLa
iXYrPDP9HckTLYQ/bmq/VsWUVBAZhQj2BlPpAAwuXnCqnRYPFqKpCiA1AwZiLRAS
ZEBq/Sz2k7oGEIS8xWBg1PriZjYH1acCC6V38WRK/Y4mpZ5+DePmyuxcYgsKAGg7
2hLTADyc4xHxMpA0SLLi
=QGtM
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
