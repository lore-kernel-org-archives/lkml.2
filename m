Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1C1XHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:07:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab1C1XHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:07:47 -0400
MIME-Version: 1.0
In-Reply-To: <4D8E36CC.7080707@fusionio.com>
References: <4D8E36CC.7080707@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Mar 2011 16:06:57 -0700
Message-ID: <AANLkTinpjfyrN0mCRZi8zPqd2=+=WGRRToFhc+MqBDSB@mail.gmail.com>
Subject: Re: [GIT PULL] block drivers for 2.6.39-rc
To: Jens Axboe <jaxboe@fusionio.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0015177407b643c385049f9301f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015177407b643c385049f9301f0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 26, 2011 at 11:56 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> Hi Linus,
>
> This is the pull request for the block driver updates for 2.6.39. Two
> things here:
>
> - Big drbd update, as per usual...
> - cciss update.

Btw, that cciss thing causes a very annoying compiler warning:

  drivers/block/cciss.c: In function =91dev_show_unique_id=92:
  drivers/block/cciss.c:617:7: warning: =91sn[0]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[1]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[2]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[3]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[4]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[5]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[6]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[7]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[8]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[9]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[10]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[11]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[12]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[13]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[14]=92 may be used
uninitialized in this function
  drivers/block/cciss.c:617:7: warning: =91sn[15]=92 may be used
uninitialized in this function

which is because the compiler doesn't really notice that those things
are only used if the error return isn't being set.

So it's a compiler mis-feature, but the thing is, the warning could
easily be avoided by just writing the code more prettily.

Just do the memcpy() unconditionally: we know that 'drv' is a valid
pointer (we just loaded 'h' off it), and we're talking about a nice
constant 16-byte copy.

IOW, a patch something like the attached.

Untested, but it looks really obvious. Hmm?

                            Linus

--0015177407b643c385049f9301f0
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glu0akie0

IGRyaXZlcnMvYmxvY2svY2Npc3MuYyB8ICAgMTkgKysrKysrKysrLS0tLS0tLS0tLQogMSBmaWxl
cyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvYmxvY2svY2Npc3MuYyBiL2RyaXZlcnMvYmxvY2svY2Npc3MuYwppbmRleCA5YmYx
Mzk4Li5lYzY5ZjBjIDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jsb2NrL2NjaXNzLmMKKysrIGIvZHJp
dmVycy9ibG9jay9jY2lzcy5jCkBAIC02MTksMjIgKzYxOSwyMSBAQCBzdGF0aWMgc3NpemVfdCBk
ZXZfc2hvd191bmlxdWVfaWQoc3RydWN0IGRldmljZSAqZGV2LAogCWludCByZXQgPSAwOwogCiAJ
c3Bpbl9sb2NrX2lycXNhdmUoJmgtPmxvY2ssIGZsYWdzKTsKKwltZW1jcHkoc24sIGRydi0+c2Vy
aWFsX25vLCBzaXplb2Yoc24pKTsKIAlpZiAoaC0+YnVzeV9jb25maWd1cmluZykKIAkJcmV0ID0g
LUVCVVNZOwotCWVsc2UKLQkJbWVtY3B5KHNuLCBkcnYtPnNlcmlhbF9ubywgc2l6ZW9mKHNuKSk7
CiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaC0+bG9jaywgZmxhZ3MpOwogCiAJaWYgKHJldCkK
IAkJcmV0dXJuIHJldDsKLQllbHNlCi0JCXJldHVybiBzbnByaW50ZihidWYsIDE2ICogMiArIDIs
Ci0JCQkJIiUwMlglMDJYJTAyWCUwMlglMDJYJTAyWCUwMlglMDJYIgotCQkJCSIlMDJYJTAyWCUw
MlglMDJYJTAyWCUwMlglMDJYJTAyWFxuIiwKLQkJCQlzblswXSwgc25bMV0sIHNuWzJdLCBzblsz
XSwKLQkJCQlzbls0XSwgc25bNV0sIHNuWzZdLCBzbls3XSwKLQkJCQlzbls4XSwgc25bOV0sIHNu
WzEwXSwgc25bMTFdLAotCQkJCXNuWzEyXSwgc25bMTNdLCBzblsxNF0sIHNuWzE1XSk7CisKKwly
ZXR1cm4gc25wcmludGYoYnVmLCAxNiAqIDIgKyAyLAorCQkJIiUwMlglMDJYJTAyWCUwMlglMDJY
JTAyWCUwMlglMDJYIgorCQkJIiUwMlglMDJYJTAyWCUwMlglMDJYJTAyWCUwMlglMDJYXG4iLAor
CQkJc25bMF0sIHNuWzFdLCBzblsyXSwgc25bM10sCisJCQlzbls0XSwgc25bNV0sIHNuWzZdLCBz
bls3XSwKKwkJCXNuWzhdLCBzbls5XSwgc25bMTBdLCBzblsxMV0sCisJCQlzblsxMl0sIHNuWzEz
XSwgc25bMTRdLCBzblsxNV0pOwogfQogc3RhdGljIERFVklDRV9BVFRSKHVuaXF1ZV9pZCwgU19J
UlVHTywgZGV2X3Nob3dfdW5pcXVlX2lkLCBOVUxMKTsKIAo=
--0015177407b643c385049f9301f0--
