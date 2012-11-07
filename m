Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2KGOGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:06:32 -0500
Received: from pilot.jhuapl.edu ([128.244.251.36]:56173 "EHLO jhuapl.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750825Ab2KGOGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:06:31 -0500
Message-ID: <509A6AA6.2000208@jhuapl.edu>
Date: Wed, 07 Nov 2012 09:05:26 -0500
From: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "key@linux.vnet.ibm.com" <key@linux.vnet.ibm.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add tpm_xenu.ko: Xen Virtual TPM frontend driver
References: <1352128197-1539-1-git-send-email-matthew.fioravante@jhuapl.edu> <20121106193921.GC28473@phenom.dumpdata.com>
In-Reply-To: <20121106193921.GC28473@phenom.dumpdata.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090304070505020605000709"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090304070505020605000709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/06/2012 02:39 PM, Konrad Rzeszutek Wilk wrote:
> On Mon, Nov 05, 2012 at 10:09:57AM -0500, Matthew Fioravante wrote:
>> This patch ports the xen vtpm frontend driver for linux
>> from the linux-2.6.18-xen.hg tree to linux-stable.
> So how does on test it ? Set it up? Use it? Is there some documentation=

> about it - if so it should be in the patch description.
Thats actually a question I had. To use this driver now you have to use=20
my vtpm mini-os domains which are currently being evaluated in the=20
xen-devel mailing list. Once they are accepted I will submit a=20
documentation update to the Xen tree.

Whats the best practice for documentation in this case? All in xen? Some =

linux/some xen? If the latter, how much goes in linux and where?
>
> I did a very very cursory look at it, see some of the comments.
>
>>
>> +
>> +
>> +static inline struct transmission *transmission_alloc(void)
>> +{
>> +     return kzalloc(sizeof(struct transmission), GFP_ATOMIC);
>> +}
>> +
>> +     static unsigned char *
>
> That is very weird tabbing? Did you run this patch through
> scripts/checkpatch.pl ?
Wow thats ugly. I ran the check script and it looks like it didn't pick=20
this up. For some reason my editor wants to autoindent like that.
Fixed.
>
>> +
>> +static const struct file_operations vtpm_ops =3D {
>> +     .owner =3D THIS_MODULE,
>> +     .llseek =3D no_llseek,
>> +     .open =3D tpm_open,
>> +     .read =3D tpm_read,
>> +     .write =3D tpm_write,
>> +     .release =3D tpm_release,
>> +};
>> +
>> +static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
>> +static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
>> +static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
>> +static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
>> +static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
>> +static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivat=
ed,
>> +             NULL);
>> +static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
>> +static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel)=
;
>> +
>> +static struct attribute *vtpm_attrs[] =3D {
>> +     &dev_attr_pubek.attr,
>> +     &dev_attr_pcrs.attr,
>> +     &dev_attr_enabled.attr,
>> +     &dev_attr_active.attr,
>> +     &dev_attr_owned.attr,
>> +     &dev_attr_temp_deactivated.attr,
>> +     &dev_attr_caps.attr,
>> +     &dev_attr_cancel.attr,
>> +     NULL,
> So are these going to show up in SysFS? If so, there should also be
> a corresponding file in Documentation/.../sysfs/something.
These are similar to the entries made by the other tpm drivers. I don't=20
see any documentation about those either. TPM maintainers, any guidance=20
there?
>
>> +#include "tpm.h"
>> +#include "tpm_vtpm.h"
>> +
>> +#undef DEBUG
>> +
>> +#define GRANT_INVALID_REF 0
> Interesting. The 0 grant value is actually a valid one. I think you
> want (-1ULL).
Is it?
drivers/block/xen-blkfront.c and
drivers/net/xen-netfront.c

do the exact same thing
>> +
>> +     init_tpm_xenbus();
>> +     return 0;
>> +}
>> +
>> +
>> +module_init(tpmif_init);
> no module_exit?
Will fix



--------------ms090304070505020605000709
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIDyjCC
A8YwggMvoAMCAQICBD/xyf0wDQYJKoZIhvcNAQEFBQAwLzELMAkGA1UEBhMCVVMxDzANBgNV
BAoTBkpIVUFQTDEPMA0GA1UECxMGQklTRENBMB4XDTEwMDYxMTE4MjIwNloXDTEzMDYxMTE4
NTIwNlowZjELMAkGA1UEBhMCVVMxDzANBgNVBAoTBkpIVUFQTDEPMA0GA1UECxMGUGVvcGxl
MTUwFgYDVQQLEw9WUE5Hcm91cC1CSVNEQ0EwGwYDVQQDExRNYXR0aGV3IEUgRmlvcmF2YW50
ZTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAnpbwVSP6o1Nb5lcW7dd3yTo9iBJdi7qz
4nANOMFPK7JOy5npKN1iiousl28U/scUJES55gPwAWYJK3uVyQAsA4adgDKi5DoD1UHDQEwp
bY7iHLJeq0NPr4BqYNqnCFPbE6HC8zSJrr4qKn+gVUQT39SIFqdiIPJwZL8FYTRQ/zsCAwEA
AaOCAbYwggGyMAsGA1UdDwQEAwIHgDArBgNVHRAEJDAigA8yMDEwMDYxMTE4MjIwNlqBDzIw
MTIwNzE3MjI1MjA2WjAbBg0rBgEEAbMlCwMBAQEBBAoWCGZpb3JhbWUxMBsGDSsGAQQBsyUL
AwEBAQIEChIIMDAxMDQyNjEwWAYJYIZIAYb6ax4BBEsMSVRoZSBwcml2YXRlIGtleSBjb3Jy
ZXNwb25kaW5nIHRvIHRoaXMgY2VydGlmaWNhdGUgbWF5IGhhdmUgYmVlbiBleHBvcnRlZC4w
KAYDVR0RBCEwH4EdTWF0dGhldy5GaW9yYXZhbnRlQGpodWFwbC5lZHUwUgYDVR0fBEswSTBH
oEWgQ6RBMD8xCzAJBgNVBAYTAlVTMQ8wDQYDVQQKEwZKSFVBUEwxDzANBgNVBAsTBkJJU0RD
QTEOMAwGA1UEAxMFQ1JMNTYwHwYDVR0jBBgwFoAUCDUpmxH52EU2CyWmF2EJMB1yqeswHQYD
VR0OBBYEFO6LYxg6r9wHZ+zdQtBHn1dZ/YTNMAkGA1UdEwQCMAAwGQYJKoZIhvZ9B0EABAww
ChsEVjcuMQMCBLAwDQYJKoZIhvcNAQEFBQADgYEAJO9HQh4YNChVLzuZqK5ARJARD8JoujGZ
fdo75quvg2jXFQe2sEjvLnxJZgm/pv8fdZakq48CWwjYHKuvIp7sDjTEsQfo+y7SpN/N2NvJ
WU5SqfK1VgYtNLRRoGJUB5Q1aZ+Dg95g3kqpyfpUMISJL8IKVLtJVfN4fggFVUYZ9wwxggGr
MIIBpwIBATA3MC8xCzAJBgNVBAYTAlVTMQ8wDQYDVQQKEwZKSFVBUEwxDzANBgNVBAsTBkJJ
U0RDQQIEP/HJ/TAJBgUrDgMCGgUAoIHLMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTEyMTEwNzE0MDUyNlowIwYJKoZIhvcNAQkEMRYEFHdMkvadKJyn6YMR
x0DY9ptWYUDMMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAK
BggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYI
KoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEgYBNC0Nqasgx9YOHcyVfJpp3/MvXowpiPeXf
hVU22sUXmVAv0NLbdXWcjnrPyg/jgK2SyoPhTanMCEswHJ+0zNWnaF2mt0PM79pVu3iW8bxW
ETHXLDbhHYn4VTYlP5g5ogMhhpFXqGwWSpbuNAoH6C5ITckRbv9Tew+v2PCrMIQ7QAAAAAAA
AA==
--------------ms090304070505020605000709--
