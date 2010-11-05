Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0KEXiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:38:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084Ab0KEXiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:38:04 -0400
MIME-Version: 1.0
In-Reply-To: <4CD48D5E.10309@oracle.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
 <20101103161638.ddc75ace.randy.dunlap@oracle.com> <AANLkTinj2sk==Jw7ZL3RvO_M7iRPW0sQy8dsvabo-V5h@mail.gmail.com>
 <4CD48D5E.10309@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Nov 2010 16:36:59 -0700
Message-ID: <AANLkTi=3f6f5MoZAX4C4ufYkopn8Z_xrR6nd-GzkoDhg@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc1 (floppy module load: no device found)
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=90e6ba6e8f566762bb049456c1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba6e8f566762bb049456c1bf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 5, 2010 at 4:03 PM, Randy Dunlap <randy.dunlap@oracle.com> wrot=
e:
> On 11/05/10 15:10, Linus Torvalds wrote:
>>
>> Randy, is this one also related to that ipv6 percpu list corruption?
>> IOW, does it go away with
>>
>> =A0 http://patchwork.ozlabs.org/patch/69939/
>>
>> like one of your other reports did?
>
> The list_debug.c message goes away, but it still gets the GP fault.

Ok. I think there's a separate floppy.c bug introduced in commit
488211844e0c ("floppy: switch to one queue per drive instead of
sharing a queue").

We do "put_disk()" on the disk device _before_ we then clean up the
queue associated with that disk.

So maybe this trivial patch is in order?

Again - UNTESTED. Jens, Vivek?

                    Linus

--90e6ba6e8f566762bb049456c1bf
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gg5pfqcs0

IGRyaXZlcnMvYmxvY2svZmxvcHB5LmMgfCAgICAyICstCiAxIGZpbGVzIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jsb2NrL2Zs
b3BweS5jIGIvZHJpdmVycy9ibG9jay9mbG9wcHkuYwppbmRleCA3NjcxMDdjLi44ZjE5YjM4IDEw
MDY0NAotLS0gYS9kcml2ZXJzL2Jsb2NrL2Zsb3BweS5jCisrKyBiL2RyaXZlcnMvYmxvY2svZmxv
cHB5LmMKQEAgLTQzNjMsOSArNDM2Myw5IEBAIG91dF91bnJlZ19ibGtkZXY6CiBvdXRfcHV0X2Rp
c2s6CiAJd2hpbGUgKGRyLS0pIHsKIAkJZGVsX3RpbWVyKCZtb3Rvcl9vZmZfdGltZXJbZHJdKTsK
LQkJcHV0X2Rpc2soZGlza3NbZHJdKTsKIAkJaWYgKGRpc2tzW2RyXS0+cXVldWUpCiAJCQlibGtf
Y2xlYW51cF9xdWV1ZShkaXNrc1tkcl0tPnF1ZXVlKTsKKwkJcHV0X2Rpc2soZGlza3NbZHJdKTsK
IAl9CiAJcmV0dXJuIGVycjsKIH0K
--90e6ba6e8f566762bb049456c1bf--
