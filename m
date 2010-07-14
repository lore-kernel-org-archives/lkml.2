Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0GNIfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 04:35:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34187 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab0GNIe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 04:34:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=mt/CnLlZZGq/guO9UsgEWYsShXQyRir/GhL6j4Fp/sPBv4E/QBOmZTth2vG+T0Nb23
         +yH0Z0NcDZK1p4PRnj1wbp72Eg2Y21WtUshIREbNNhr/kvvdGh9qEetGBSK17No5UhI/
         KnJ1X4dSwTtM2fMrEq7iGTgJwf53MY9fmOAE0=
Message-ID: <4C3D76AE.6090509@polito.it>
Date: Wed, 14 Jul 2010 10:34:54 +0200
From: Roberto Sassu <roberto.sassu@polito.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Seiji Munetoh <seiji.munetoh@gmail.com>
CC: Shaz <shazalive@gmail.com>, linux-ima-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [Linux-ima-user] [RFC][PATCH] ima: add default rule for initramfs
 files
References: <1278428902-27079-1-git-send-email-roberto.sassu@polito.it>	<1278594883.3313.33.camel@localhost.localdomain>	<AANLkTilMKH5M0d8iyACTDLMwZb1WgyJVrd9e04H2cy95@mail.gmail.com>	<AANLkTinWK9mX6lVUvWzgbh7QQ3ZItnrUE4WBJEkOqm2q@mail.gmail.com> <AANLkTilI8klNawzxVc-wxREJwktBKW2G4GvYeyMueGJM@mail.gmail.com>
In-Reply-To: <AANLkTilI8klNawzxVc-wxREJwktBKW2G4GvYeyMueGJM@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090401070804010801040700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090401070804010801040700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 07/14/2010 08:29 AM, Seiji Munetoh wrote:
> On Wed, Jul 14, 2010 at 2:42 PM, Shaz<shazalive@gmail.com>  wrote:
>   =20
>>
>> On Wed, Jul 14, 2010 at 3:08 AM, Seiji Munetoh<seiji.munetoh@gmail.com=
>
>> wrote:
>>     =20
>>> On Thu, Jul 8, 2010 at 10:14 PM, Mimi Zohar<zohar@linux.vnet.ibm.com>=

>>> wrote:
>>>       =20
>>>> On Tue, 2010-07-06 at 17:08 +0200, Roberto Sassu wrote:
>>>>         =20
>>>>> This patch modifies the default policy shipped with IMA, in order t=
o
>>>>> avoid measurements
>>>>> of files in the initial ramdisk. Those files can be measured early =
in
>>>>> the boot process
>>>>> by the bootloader.
>>>>> The patch applies to latest version of the mainline kernel 2.6.35-r=
c4.
>>>>>           =20
>>>> Yes, the initramfs measurements are therefore redundant, as they're
>>>> already included in the initramfs measurement, but perhaps, as the
>>>> number of initramfs is very limited and the individual file measurem=
ents
>>>> supplies additional information, it wouldn't hurt to keep the indivi=
dual
>>>> file measurements as well.  These measurements could potentially hel=
p in
>>>> identifying initramfs changes.
>>>>
>>>> Would appreciate other opinions before accepting this change.
>>>>         =20
>>> The hash value of the initramfs is unstable since it was generated
>>> at the time of kernel installation.
>>> So still I want to check  the individual used file in initramfs.
>>>       =20
>> If initrd is measured by boot loader then changes to individual files =
should
>> not be measured as this IS redundant. Use the new hash of the initrd a=
s an
>> integrity metric. Why would this not be enough?
>>     =20
> This depends on remote verifier.
> Creating the initramfs is client side task and  the hash value of initr=
amfs
> will vary each clients.
>
> For me, validation of  current measurements is easier than validation o=
f
> initramfs. And it seems the overhead of this redundancy is less painful=
=2E
>
> But some system can validate (or trust) the initramfs measured by IPL.
> So, I would suggest that add Kconfig option to change the default polic=
y.
>
> IMHO, if the eventlog contains fsmagic information for each measurement=
s.
> Verifier can skip the validation of RAMFS measurement easily.
>
>   =20
This is true, the initramfs's digest cannot be validated by a remote=20
verifier. But in my opinion there are three main reasons for don't=20
include those files in the measurement list.
First, this is a readonly system and measures don't change in time; so=20
if you create the image under a controlled environment and its digest=20
doesn't change you can assert it will behave correctly.
Second, including those measurements may be very confusing for a=20
verifier since there may be multiple versions of the same object (the=20
initramfs changes very rarely in respect to other files).
Lastly, a pratical use of IMA is to load a custom policy. The better=20
place to do that is the initramfs but measurements cannot be taken until =

the policy is loaded. The only way, as Shaz mentioned in a previous=20
email, to keep track of all actions made during the boot process is that =

you have the initramfs image measured early by the boot loader.


Roberto

> --
> Seiji
>
> -----------------------------------------------------------------------=
-------
> This SF.net email is sponsored by Sprint
> What will you do first with EVO, the first 4G phone?
> Visit sprint.com/first -- http://p.sf.net/sfu/sprint-com-first
> _______________________________________________
> Linux-ima-user mailing list
> Linux-ima-user@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-ima-user
>   =20



--------------ms090401070804010801040700
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIWGDCC
BLMwggOboAMCAQICARQwDQYJKoZIhvcNAQEFBQAwQTEQMA4GA1UEChMHRXVyb1BLSTEtMCsG
A1UEAxMkRXVyb1BLSSBSb290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA2MTAyNDEz
MzEzM1oXDTEwMTIzMTEyNTk1OVowUTELMAkGA1UEBhMCSVQxEDAOBgNVBAoTB0V1cm9QS0kx
MDAuBgNVBAMTJ0V1cm9QS0kgSXRhbGlhbiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPbJ3y5bE0iL2iFW59R4KGHS3iTc22mq2GlD
aOZLE3Xz1wTvB/yBl5e4ntMZeEeWTW9JInNRTtfC3mcLk0gnEdK1rQZbe4lQwBVHdkG8LvRQ
DWHIkZNuccoUpQXMv+JbZjI6m7rHfU2CN/YCvFY9QL08xXsfDxvX2Ee4S7EwJiSEEJSiy+R0
0uTfvfn27d8a6LCqYLzlInRlz4C2CUbk+U2UAwjYEPTP2ziqFxztysbxC3fjqH8e6P5wIPXO
S5cSYnVaEyp21VXhAOamVJEGlQCdVoTHs+pPBYqCBuNhBfienUPaEDHHUUYHZ2nS4eNzd9XO
u+5hFi1/8hVZxN4sbdECAwEAAaOCAaQwggGgMEwGCWCGSAGG+EIBDQQ/Fj1Jc3N1ZWQgdW5k
ZXIgcG9saWN5OgogaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290L2Nwcy8xLjEvMGUG
CCsGAQUFBwEBBFkwVzAoBggrBgEFBQcwAYYcaHR0cDovL29jc3AuZXVyb3BraS5vcmc6ODAy
NjArBggrBgEFBQcwAoYfaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290LzA7BgNVHR8E
NDAyMDCgLqAshipodHRwOi8vd3d3LmV1cm9wa2kub3JnL2NhL3Jvb3QvY3JsL2NybC5kZXIw
DAYDVR0TBAUwAwEB/zBOBgNVHSAERzBFMEMGCisGAQQBqQcBAQEwNTAzBggrBgEFBQcCARYn
aHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9yb290L2Nwcy8xLjEvMA4GA1UdDwEB/wQEAwIB
9jAdBgNVHQ4EFgQUjl4HtzG0Gbu5BJU0rMX9016KQsAwHwYDVR0jBBgwFoAUjNyLsaVKkOdO
iHMYPJ3VXn7kss0wDQYJKoZIhvcNAQEFBQADggEBAFjlAWMiL7uhEAVcrPeMXsbQU+bQNbP1
TBqyBoMCMJ4RakM7/67AsmqpKGIYwhjVkSNHhscRl5BuSiyviHOLbWUJ9tAAKt6hzMDr1J4O
vWSHSn8y9fSlyQU8+fQE8FHxXT3Aa7aLYVqsqr0ppmxRDL/9b/mdUVcMXiKFAdopFzhXIigf
ZFh6MW/o7/GEiDMGsovCiwKJ5ZL46zGRDaS+O0aRYQv2PHZaWrC8i0OPwghlTeB2DfUBzm0u
rPijBATdjzP8yO3YGymFZOIG08Roe4bwzrANGzX5luBk3lNmtXTPHoUtRLn3ADa+IUGwK6VY
WHYJe1+uUHRNziQu/Zsb858wggU/MIIEJ6ADAgECAgIJzzANBgkqhkiG9w0BAQUFADBRMQsw
CQYDVQQGEwJJVDEQMA4GA1UEChMHRXVyb1BLSTEwMC4GA1UEAxMnRXVyb1BLSSBJdGFsaWFu
IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA2MTEwNjE3MTU1OVoXDTEwMTIzMTEyNTk1
OVowZTELMAkGA1UEBhMCSVQxHjAcBgNVBAoTFVBvbGl0ZWNuaWNvIGRpIFRvcmlubzE2MDQG
A1UEAxMtUG9saXRlY25pY28gZGkgVG9yaW5vIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA/s1vopfmSp2eqKG/jW4H5YyfrZc/jWEn
ctMMm7TlVT+ryxJ2ifYV/7VyuYVIGdnCBnmJiav6uhePqpHyuejEZ+IdCchk04BSBbgzkSbW
akw2ekv1SKm8WfvhxHbiSo/t//LQEANMJ+XeeqGl1TRR8gdMC6erWFGdl5FcuOpMoaqW6Dsz
VGlOAf7Uo/DExZ0/9cw77GTRoDTA3vi1QJEYGaAAvI2/flaU8gn4QoktjowchDXBylVsyqs+
ux3v7m3H0cgC3q62t2om2badk40F9XH1w2WPLQB6rSl+TPDxkl2kkR4goQprXR0b0OujS5AD
q5Ds2w7YPj5h4J6ebsbIUQIDAQABo4ICCzCCAgcwdQYJYIZIAYb4QgENBGgWZklzc3VlZCB1
bmRlciBwb2xpY2llczoKIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9jcHMvMS4x
LwogaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC9jcHMvMS4xLzBcBggrBgEFBQcBAQRQ
ME4wKAYIKwYBBQUHMAGGHGh0dHA6Ly9vY3NwLmV1cm9wa2kub3JnOjgwMjYwIgYIKwYBBQUH
MAKGFmh0dHA6Ly93d3cuZXVyb3BraS5vcmcwPAYDVR0fBDUwMzAxoC+gLYYraHR0cDovL3d3
dy5ldXJvcGtpLm9yZy9jYS9pdDIvY3JsMDMvY3JsLmRlcjAPBgNVHRMBAf8EBTADAQH/MIGT
BgNVHSAEgYswgYgwQwYKKwYBBAGpBwEBATA1MDMGCCsGAQUFBwIBFidodHRwOi8vd3d3LmV1
cm9wa2kub3JnL2NhL3Jvb3QvY3BzLzEuMS8wQQYKKwYBBAGpBwIBATAzMDEGCCsGAQUFBwIB
FiVodHRwOi8vd3d3LmV1cm9wa2kub3JnL2NhL2l0L2Nwcy8xLjEvMAsGA1UdDwQEAwIB9jAd
BgNVHQ4EFgQUCf0lGW/jaHyCazVzvCgAviw8OjgwHwYDVR0jBBgwFoAUjl4HtzG0Gbu5BJU0
rMX9016KQsAwDQYJKoZIhvcNAQEFBQADggEBANfGdD6B98NUwBOVYIiuo+SNfw8Afjr2oFHL
YEHYhKdBED1WBckhK610v2zJctramnrqdd+xfyzmkyNm48OtkiVetYzXbgYeyMGxhO8HrJ1Z
tf1yEN0lL8HgdK3lmJeLYNYH/cwZ5SlKwvTR/VENHLYlWsgWk47ut7W8+Zd/ESwzNdJUCBUM
oQnGZ3giyhAXKAgIOckwL0g8KmnceY7JY4L1G++1OuOoUcgg2jRPxcVmHVEe/cM0WHfUcigD
XSBTIxAiDwlQ7ni97yX1RqBV/6IVdRDYKyjgYkdYcwU9ZuOKUP4Pl5KKCegLOHRoo5kX6V1o
7b2IZGBFoVmkag4m4kkwggYLMIIE86ADAgECAgIDwTANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQDEy1Qb2xp
dGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMDgxMjA1MTYw
MDAwWhcNMTAxMjMwMTIwMDAwWjB5MQswCQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25p
Y28gZGkgVG9yaW5vMTEwLwYDVQQLEyhEaXBhcnRpbWVudG8gZGkgQXV0b21hdGljYSBlIElu
Zm9ybWF0aWNhMRcwFQYDVQQDEw5Sb2JlcnRvICBTYXNzdTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAOS/leMNzG5v7FG73ythWtNPOdq8MEFpzg7mjy4M7UsS9+scb7QE8TOX
365q/+mBwxZ7qW+OhNKfgv14A3y/quju5P7mjTmTNvKWDpsUBjC+tCs+WpWsgIPc2xxWPrR7
br04U/SYYNsxynh1TtO2gsQrHIj9S/wNiNRP8GGPCAiuYRlaL2CeSVn4JEKcT0zOeLIIqfDp
3Ad3YeBhj+cR3TrmO9TyGTPCAb1oyq9wuA1Tx044rqSQNbp0e0RvOrwAIpD/2mNPP3ReTeB5
3aSgq0pCHoH1s2AcY/jWJ1joYFC9hh/2DqZRvMNIsM7Uce5Iiz2sgl1I61IUD4658HYzCmMC
AwEAAaOCAq8wggKrMIGVBglghkgBhvhCAQ0EgYcWgYRJc3N1ZWQgdW5kZXIgcG9saWNpZXM6
CiBodHRwOi8vd3d3LmV1cm9wa2kub3JnL2NhL3Jvb3QvY3BzLzEuMS8KIGh0dHA6Ly93d3cu
ZXVyb3BraS5vcmcvY2EvaXQvY3BzLzEuMS8KIGh0dHA6Ly9jYS5wb2xpdG8uaXQvY3BzLzIu
MS8wEQYJYIZIAYb4QgEBBAQDAgCwMGMGCCsGAQUFBwEBBFcwVTAoBggrBgEFBQcwAYYcaHR0
cDovL29jc3AuZXVyb3BraS5vcmc6ODAyNjApBggrBgEFBQcwAoYdaHR0cDovL3d3dy5ldXJv
cGtpLm9yZy9jYS9pdC8wMgYDVR0fBCswKTAnoCWgI4YhaHR0cDovL2NhLnBvbGl0by5pdC9j
cmwwMy9jcmwuZGVyMAwGA1UdEwEB/wQCMAAwOgYDVR0RBDMwMYEXcm9iZXJ0by5zYXNzdUBw
b2xpdG8uaXSgFgYKKwYBBAGVYgIBAaAIFgYwMjEzMDUwgc0GA1UdIASBxTCBwjBDBgorBgEE
AakHAQEBMDUwMwYIKwYBBQUHAgEWJ2h0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9j
cHMvMS4xLzBBBgorBgEEAakHAgEBMDMwMQYIKwYBBQUHAgEWJWh0dHA6Ly93d3cuZXVyb3Br
aS5vcmcvY2EvaXQvY3BzLzEuMS8wOAYKKwYBBAGVYgECATAqMCgGCCsGAQUFBwIBFhxodHRw
Oi8vY2EucG9saXRvLml0L2Nwcy8yLjEvMAsGA1UdDwQEAwIE8DAdBgNVHQ4EFgQUP+37DpRL
6r5BNjgsgFjI8MHvGTcwHwYDVR0jBBgwFoAUCf0lGW/jaHyCazVzvCgAviw8OjgwDQYJKoZI
hvcNAQEFBQADggEBADRj0OWMglzLXTPuKND9gMTHd1iRPzRNI1TiYFN/WIyua3mNev65wKn3
5VxbbMV6k7zuxxdC7o+iYRLepVOnpw90Af/SiJRc9QI4rk8tzSr5xII7vI0fPvclrjSMymXC
vwKrbYwrKe0FhBnSZ8AoewXoHDQ8f64heLIU8mLWuwo1+brq0pJUH5Q+69WAGD03ln+lFhk2
KqvVv8yAD21PydrS7Uk2ZLE7l7/+BTQBY8ZjpNRZ44C6+o7lou2zN6lkWtVHBwUNVdfu3wkS
TdtCm/yxR8XUlFyZkLHfhY19VW4luxb7KZ4GiPKDERdQwBb0kja4eqSOBkAPWZ9Y8zpv4bAw
ggYLMIIE86ADAgECAgIDwTANBgkqhkiG9w0BAQUFADBlMQswCQYDVQQGEwJJVDEeMBwGA1UE
ChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQDEy1Qb2xpdGVjbmljbyBkaSBUb3Jp
bm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMDgxMjA1MTYwMDAwWhcNMTAxMjMwMTIw
MDAwWjB5MQswCQYDVQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTEw
LwYDVQQLEyhEaXBhcnRpbWVudG8gZGkgQXV0b21hdGljYSBlIEluZm9ybWF0aWNhMRcwFQYD
VQQDEw5Sb2JlcnRvICBTYXNzdTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOS/
leMNzG5v7FG73ythWtNPOdq8MEFpzg7mjy4M7UsS9+scb7QE8TOX365q/+mBwxZ7qW+OhNKf
gv14A3y/quju5P7mjTmTNvKWDpsUBjC+tCs+WpWsgIPc2xxWPrR7br04U/SYYNsxynh1TtO2
gsQrHIj9S/wNiNRP8GGPCAiuYRlaL2CeSVn4JEKcT0zOeLIIqfDp3Ad3YeBhj+cR3TrmO9Ty
GTPCAb1oyq9wuA1Tx044rqSQNbp0e0RvOrwAIpD/2mNPP3ReTeB53aSgq0pCHoH1s2AcY/jW
J1joYFC9hh/2DqZRvMNIsM7Uce5Iiz2sgl1I61IUD4658HYzCmMCAwEAAaOCAq8wggKrMIGV
BglghkgBhvhCAQ0EgYcWgYRJc3N1ZWQgdW5kZXIgcG9saWNpZXM6CiBodHRwOi8vd3d3LmV1
cm9wa2kub3JnL2NhL3Jvb3QvY3BzLzEuMS8KIGh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Ev
aXQvY3BzLzEuMS8KIGh0dHA6Ly9jYS5wb2xpdG8uaXQvY3BzLzIuMS8wEQYJYIZIAYb4QgEB
BAQDAgCwMGMGCCsGAQUFBwEBBFcwVTAoBggrBgEFBQcwAYYcaHR0cDovL29jc3AuZXVyb3Br
aS5vcmc6ODAyNjApBggrBgEFBQcwAoYdaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9pdC8w
MgYDVR0fBCswKTAnoCWgI4YhaHR0cDovL2NhLnBvbGl0by5pdC9jcmwwMy9jcmwuZGVyMAwG
A1UdEwEB/wQCMAAwOgYDVR0RBDMwMYEXcm9iZXJ0by5zYXNzdUBwb2xpdG8uaXSgFgYKKwYB
BAGVYgIBAaAIFgYwMjEzMDUwgc0GA1UdIASBxTCBwjBDBgorBgEEAakHAQEBMDUwMwYIKwYB
BQUHAgEWJ2h0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2Evcm9vdC9jcHMvMS4xLzBBBgorBgEE
AakHAgEBMDMwMQYIKwYBBQUHAgEWJWh0dHA6Ly93d3cuZXVyb3BraS5vcmcvY2EvaXQvY3Bz
LzEuMS8wOAYKKwYBBAGVYgECATAqMCgGCCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0
L2Nwcy8yLjEvMAsGA1UdDwQEAwIE8DAdBgNVHQ4EFgQUP+37DpRL6r5BNjgsgFjI8MHvGTcw
HwYDVR0jBBgwFoAUCf0lGW/jaHyCazVzvCgAviw8OjgwDQYJKoZIhvcNAQEFBQADggEBADRj
0OWMglzLXTPuKND9gMTHd1iRPzRNI1TiYFN/WIyua3mNev65wKn35VxbbMV6k7zuxxdC7o+i
YRLepVOnpw90Af/SiJRc9QI4rk8tzSr5xII7vI0fPvclrjSMymXCvwKrbYwrKe0FhBnSZ8Ao
ewXoHDQ8f64heLIU8mLWuwo1+brq0pJUH5Q+69WAGD03ln+lFhk2KqvVv8yAD21PydrS7Uk2
ZLE7l7/+BTQBY8ZjpNRZ44C6+o7lou2zN6lkWtVHBwUNVdfu3wkSTdtCm/yxR8XUlFyZkLHf
hY19VW4luxb7KZ4GiPKDERdQwBb0kja4eqSOBkAPWZ9Y8zpv4bAxggNOMIIDSgIBATBrMGUx
CzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBkaSBUb3Jpbm8xNjA0BgNVBAMT
LVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQICA8EwCQYF
Kw4DAhoFAKCCAbgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
MTAwNzE0MDgzNDU0WjAjBgkqhkiG9w0BCQQxFgQUVlwXG5KxhOBEaBeuswSb9nq0SqYwXwYJ
KoZIhvcNAQkPMVIwUDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMHoGCSsGAQQBgjcQBDFt
MGswZTELMAkGA1UEBhMCSVQxHjAcBgNVBAoTFVBvbGl0ZWNuaWNvIGRpIFRvcmlubzE2MDQG
A1UEAxMtUG9saXRlY25pY28gZGkgVG9yaW5vIENlcnRpZmljYXRpb24gQXV0aG9yaXR5AgID
wTB8BgsqhkiG9w0BCRACCzFtoGswZTELMAkGA1UEBhMCSVQxHjAcBgNVBAoTFVBvbGl0ZWNu
aWNvIGRpIFRvcmlubzE2MDQGA1UEAxMtUG9saXRlY25pY28gZGkgVG9yaW5vIENlcnRpZmlj
YXRpb24gQXV0aG9yaXR5AgIDwTANBgkqhkiG9w0BAQEFAASCAQDAbBXeUGDHKKBn/lgLs7u+
08IUBIGhu4Z+d4kxc2jDtbs9U6Gn6qXaQftd9E+jxNvPV0jgFpOK5vXKQyIS54t2/u4a/nCA
02PZ88DgfvrgXXJIe3kT5CBjh6ysqOM3NmnV+nqT9anXohNfvRg18bH5MnI1vBoj8t3R/bvy
Asmbj8v//N4gcokseZ74vSi0b1ALmp0cNGHyeNAfkCK7BD4P1i6s6N6RrrxsZozTvU2+9ZCU
2UWxNM5R9LI5qG0b9H40jigRvC5+UC96UWMJ4tTDupwZQIomT9GhL6tFrqGRCUwfkLSEscad
LEUUUMCRLH6jup+hV1qSu0mZdAXS6WmgAAAAAAAA
--------------ms090401070804010801040700--
