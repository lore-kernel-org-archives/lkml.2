Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab0IYLCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 07:02:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43858 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0IYLCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 07:02:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=TqXgAOSYEoMv8XIMKv/Z6i/NUtrXKivjV1f8x346W3tW22BzpwBcJOWF6/x2gM1VNE
         AoCxvHCZKZGKZf4NpPA3S4UMrS2xd4jjHREEDxSvJjgxNgvpoWtjaV/cm9GFhZj9U8zk
         Pv1g0D9nnIpakJMIJ/L9zm3CjQ9LUnBmtLCSc=
MIME-Version: 1.0
Date: Sat, 25 Sep 2010 12:02:29 +0100
Message-ID: <AANLkTi=ng5OGhJFE14V51hJMh5vNCDFzfWySWZjeWemZ@mail.gmail.com>
Subject: User interactivity measurements.
From: James Courtier-Dutton <james.dutton@gmail.com>
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016368340c06898410491136ebc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016368340c06898410491136ebc
Content-Type: text/plain; charset=UTF-8

Hi,

I was trying to work out how I would measure how good the user interactivity is.
I thought that I could use the keyboard repeat rate to do this.
The repeat rate should be constant, so if I measure it, any large
variations indicate latency problems.
The attach program measures the repeat rate that is observed by the application.
To use the program, just keep the ENTER key down until the program exists.
Compile it with "gcc k.c"
Run it with "./a.out >output" and then examine the output in file "output"

Example output under xfce4
0.050032, 0
0.049969, 0
0.050017, 0
0.049970, 0
0.050034, 0
0.049970, 0
0.050038, 0
0.049962, 0
0.049934, 0
0.049987, 0
0.049980, 0
0.060135, 1
0.049878, 0
0.050150, 0
0.049934, 0

As you can see, only one value that is far away from the normal of
0.050000 seconds.
The 1 in the last column tries to identify problem values.

Example output from the same computer, but under gnome and compiz.
0.049984, 1
0.040191, 1
0.029801, 0
0.040048, 1
0.040022, 1
0.029998, 0
0.049945, 1
0.030110, 0
0.049925, 1
0.050020, 1
0.039993, 1
0.039969, 1

As you can see, the variability under gnome and compiz is far worse
than xfce4 with the normal value being about 0.030000 seconds. In
fact, it is so variable, that it is hard to tell what the normal value
should be!!!  There appear to be values clumped around 0.4, and around
0.3 and around 0.5.


Can anyone spot any problems with this approach to measuring the user
interactivity and perceived latency.
For me, the latency was far worse, to the eye, on gnome/compiz than
xfce4 and these results seem to prove it.

Kind Regards

James

--0016368340c06898410491136ebc
Content-Type: text/x-csrc; charset=US-ASCII; name="k.c"
Content-Disposition: attachment; filename="k.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_geicyiw10

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzeXMvdGltZS5oPgojaW5jbHVkZSA8aW50dHlw
ZXMuaD4KCmludCBtYWluKCkgewoJaW50IGtleTsKCWludCBuOwoJaW50IHRtcDsKCXVpbnQ2NF90
IHRvdGFsID0gMDsKCWludCBzaXplID0gMTAwOwoJaW50IHJlcGVhdF9yYXRlID0gMzAwMDA7Cglz
dHJ1Y3QgdGltZXZhbCB0aW1lMVtzaXplXTsKCXN0cnVjdCB0aW1ldmFsIHRpbWUyOwoJc3RydWN0
IHRpbWV2YWwgdGltZWRpZmY7CgkvKiBBZGQgb25lIGJlY2F1c2Ugd2UgZHJvcCB0aGUgZmlyc3Qg
a2V5ICovCglzaXplKys7CgoJZnByaW50ZihzdGRlcnIsICJQcmVzcyBhbmQgaG9sZCBFTlRFUiBr
ZXlcbiIpOwoJdG1wID0gZ2V0dGltZW9mZGF5KCZ0aW1lMVswXSwgTlVMTCk7Cglmb3IgKG4gPSAx
OyBuIDwgc2l6ZTsgbisrKSB7CgkJa2V5ID0gZ2V0Y2hhcigpOwoJCXRtcCA9IGdldHRpbWVvZmRh
eSgmdGltZTFbbl0sIE5VTEwpOwoJfQoJLyogSWdub3JlIHRoZSBmaXJzdCBrZXkgKi8KCWZvciAo
biA9IDI7IG4gPCBzaXplOyBuKyspIHsKCQl0aW1lZGlmZi50dl9zZWMgPSB0aW1lMVtuXS50dl9z
ZWMgLSB0aW1lMVtuLTFdLnR2X3NlYzsKCQl0aW1lZGlmZi50dl91c2VjID0gdGltZTFbbl0udHZf
dXNlYyAtIHRpbWUxW24tMV0udHZfdXNlYzsKCQlpZiAodGltZWRpZmYudHZfdXNlYyA8IDApIHsK
CQkJdGltZWRpZmYudHZfdXNlYyArPSAxMDAwMDAwOwoJCQl0aW1lZGlmZi50dl9zZWMgLT0gMTsK
CQl9CgkJdG90YWwgKz0gdGltZWRpZmYudHZfdXNlYzsKCQl0bXAgPSAwOwoJCWlmICgodGltZWRp
ZmYudHZfdXNlYyA+IChyZXBlYXRfcmF0ZSArIDEwMDApKSB8fCAodGltZWRpZmYudHZfdXNlYyA8
IChyZXBlYXRfcmF0ZSAtIDEwMDApKSkgdG1wID0gMTsKCQlwcmludGYoIiVsZC4lMDZsZCwgJWRc
biIsIHRpbWVkaWZmLnR2X3NlYywgdGltZWRpZmYudHZfdXNlYywgdG1wKTsKCX0KCXByaW50Zigi
VG90YWwgPSAlbHVcbiIsIHRvdGFsIC8gKHNpemUgLSAxKSk7Cn0KCg==
--0016368340c06898410491136ebc--
