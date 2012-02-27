Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab2B0I2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:28:04 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:11778 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2B0I2C (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 27 Feb 2012 03:28:02 -0500
Message-Id: <4F4B4C9D0200007800074E09@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 27 Feb 2012 08:27:57 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: constify all instances of "struct
 attribute_group"
References: <4F4786FD0200007800074A0C@nat28.tlf.novell.com>
 <20120226160230.GA2274@phenom.dumpdata.com>
In-Reply-To: <20120226160230.GA2274@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartCFE1C69D.3__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartCFE1C69D.3__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

>>> On 26.02.12 at 17:02, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> =
wrote:
> On Fri, Feb 24, 2012 at 11:47:57AM +0000, Jan Beulich wrote:
>> The functions these get passed to have been taking pointers to const
>> since at least 2.6.16.
>=20
> What is this based on? I get:

Plain 3.3-rc4.

> HEAD is now at b01543d... Linux 3.3-rc4
> konrad@phenom:~/ssd/linux$ patch -p1 < /tmp/jan-1
> patching file drivers/xen/sys-hypervisor.c
> Hunk #1 FAILED at 97.
> Hunk #2 FAILED at 210.
> Hunk #3 FAILED at 340.
> 3 out of 3 hunks FAILED -- saving rejects to file=20
> drivers/xen/sys-hypervisor.c.rej
> patching file drivers/xen/xen-balloon.c
> Hunk #1 FAILED at 207.
> 1 out of 1 hunk FAILED -- saving rejects to file drivers/xen/xen-balloon.=
c.rej
> patching file drivers/xen/xen-selfballoon.c
> Hunk #1 FAILED at 488.
> 1 out of 1 hunk FAILED -- saving rejects to file=20
> drivers/xen/xen-selfballoon.c.rej

Is /tmp/jan-1 perhaps suffering whitespace corruption (which would
have happened at your end, as I can take the tail of your response,
remove the reply quotation, and apply it successfully), even though
I don't think we had problems of this kind in the past? I'll attach the
patch here, just in case.

Jan

>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>=20
>> ---
>>  drivers/xen/sys-hypervisor.c  |    6 +++---
>>  drivers/xen/xen-balloon.c     |    2 +-
>>  drivers/xen/xen-selfballoon.c |    2 +-
>>  3 files changed, 5 insertions(+), 5 deletions(-)
>>=20
>> --- 3.3-rc4/drivers/xen/sys-hypervisor.c
>> +++ 3.3-rc4-xen-const-attribute_group/drivers/xen/sys-hypervisor.c
>> @@ -97,7 +97,7 @@ static struct attribute *version_attrs[]
>>  	NULL
>>  };
>> =20
>> -static struct attribute_group version_group =3D {
>> +static const struct attribute_group version_group =3D {
>>  	.name =3D "version",
>>  	.attrs =3D version_attrs,
>>  };
>> @@ -210,7 +210,7 @@ static struct attribute *xen_compile_att
>>  	NULL
>>  };
>> =20
>> -static struct attribute_group xen_compilation_group =3D {
>> +static const struct attribute_group xen_compilation_group =3D {
>>  	.name =3D "compilation",
>>  	.attrs =3D xen_compile_attrs,
>>  };
>> @@ -340,7 +340,7 @@ static struct attribute *xen_properties_
>>  	NULL
>>  };
>> =20
>> -static struct attribute_group xen_properties_group =3D {
>> +static const struct attribute_group xen_properties_group =3D {
>>  	.name =3D "properties",
>>  	.attrs =3D xen_properties_attrs,
>>  };
>> --- 3.3-rc4/drivers/xen/xen-balloon.c
>> +++ 3.3-rc4-xen-const-attribute_group/drivers/xen/xen-balloon.c
>> @@ -207,7 +207,7 @@ static struct attribute *balloon_info_at
>>  	NULL
>>  };
>> =20
>> -static struct attribute_group balloon_info_group =3D {
>> +static const struct attribute_group balloon_info_group =3D {
>>  	.name =3D "info",
>>  	.attrs =3D balloon_info_attrs
>>  };
>> --- 3.3-rc4/drivers/xen/xen-selfballoon.c
>> +++ 3.3-rc4-xen-const-attribute_group/drivers/xen/xen-selfballoon.c
>> @@ -488,7 +488,7 @@ static struct attribute *selfballoon_att
>>  	NULL
>>  };
>> =20
>> -static struct attribute_group selfballoon_group =3D {
>> +static const struct attribute_group selfballoon_group =3D {
>>  	.name =3D "selfballoon",
>>  	.attrs =3D selfballoon_attrs
>>  };
>>=20
>>=20




--=__PartCFE1C69D.3__=
Content-Type: text/plain; name="linux-3.3-rc4-xen-const-attribute_group.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-3.3-rc4-xen-const-attribute_group.patch"

xen: constify all instances of "struct attribute_group"=0A=0AThe functions =
these get passed to have been taking pointers to const=0Asince at least =
2.6.16.=0A=0ASigned-off-by: Jan Beulich <jbeulich@suse.com>=0A=0A---=0A =
drivers/xen/sys-hypervisor.c  |    6 +++---=0A drivers/xen/xen-balloon.c   =
  |    2 +-=0A drivers/xen/xen-selfballoon.c |    2 +-=0A 3 files changed, =
5 insertions(+), 5 deletions(-)=0A=0A--- 3.3-rc4/drivers/xen/sys-hypervisor=
.c=0A+++ 3.3-rc4-xen-const-attribute_group/drivers/xen/sys-hypervisor.c=0A@=
@ -97,7 +97,7 @@ static struct attribute *version_attrs[]=0A 	NULL=0A =
};=0A =0A-static struct attribute_group version_group =3D {=0A+static =
const struct attribute_group version_group =3D {=0A 	.name =3D =
"version",=0A 	.attrs =3D version_attrs,=0A };=0A@@ -210,7 +210,7 @@ =
static struct attribute *xen_compile_att=0A 	NULL=0A };=0A =0A-static =
struct attribute_group xen_compilation_group =3D {=0A+static const struct =
attribute_group xen_compilation_group =3D {=0A 	.name =3D "compilation",=0A=
 	.attrs =3D xen_compile_attrs,=0A };=0A@@ -340,7 +340,7 @@ static =
struct attribute *xen_properties_=0A 	NULL=0A };=0A =0A-static struct =
attribute_group xen_properties_group =3D {=0A+static const struct =
attribute_group xen_properties_group =3D {=0A 	.name =3D "properties",=0A =
	.attrs =3D xen_properties_attrs,=0A };=0A--- 3.3-rc4/drivers/xen/xe=
n-balloon.c=0A+++ 3.3-rc4-xen-const-attribute_group/drivers/xen/xen-balloon=
.c=0A@@ -207,7 +207,7 @@ static struct attribute *balloon_info_at=0A 	=
NULL=0A };=0A =0A-static struct attribute_group balloon_info_group =3D =
{=0A+static const struct attribute_group balloon_info_group =3D {=0A 	=
.name =3D "info",=0A 	.attrs =3D balloon_info_attrs=0A };=0A--- =
3.3-rc4/drivers/xen/xen-selfballoon.c=0A+++ 3.3-rc4-xen-const-attribute_gro=
up/drivers/xen/xen-selfballoon.c=0A@@ -488,7 +488,7 @@ static struct =
attribute *selfballoon_att=0A 	NULL=0A };=0A =0A-static struct attribute_g=
roup selfballoon_group =3D {=0A+static const struct attribute_group =
selfballoon_group =3D {=0A 	.name =3D "selfballoon",=0A 	.attrs =3D =
selfballoon_attrs=0A };=0A
--=__PartCFE1C69D.3__=--
