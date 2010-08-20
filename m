Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0HTNxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:53:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48346 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0HTNxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kPOJqalFhQbjk1zXJ0GVd4e8G/X3QU9xqZe8qqlc2ZahGi1BTqIYonjlNL23tIn1cY
         IIt4qSxZL3bguTJC0u+h4w9lNjEckNCTJJLwSbEQvb1D5xRWjUx7omhp+LtHQSYSyFVd
         cQ0uL76ukBXN8LkmHTHn/WU+Nhfg6tj1yuDMY=
MIME-Version: 1.0
In-Reply-To: <4C6E799A.7060902@cs.cmu.edu>
References: <4C6D9289.4000702@cs.cmu.edu>
	<20100819203435.GA28508@suse.de>
	<4C6E799A.7060902@cs.cmu.edu>
Date: Fri, 20 Aug 2010 21:53:31 +0800
Message-ID: <AANLkTikkiD7qfHqkMSq3id=ap6V6gvsddca+tc8Q+bk0@mail.gmail.com>
Subject: Re: 2.6.36-rc1 oopses at boot time in kobject allocation
From: Ming Lei <tom.leiming@gmail.com>
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016363ba1f8cb84cb048e419f25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363ba1f8cb84cb048e419f25
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2010/8/20 Benjamin Gilbert <bgilbert@cs.cmu.edu>:
> On 08/19/2010 04:34 PM, Greg KH wrote:
>> On Thu, Aug 19, 2010 at 04:22:33PM -0400, Benjamin Gilbert wrote:
>>> 2.6.36-rc1 and 2.6.36-rc1-127-g763008c fail to boot for me:
>>
>> Can you run 'git bisect' to try to track this down?
>
> commit f8a4bd3456b988fc73b2c291b9e01b434c8fa940
> Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Date: =A0 Fri Jun 4 00:54:43 2010 -0700
>
> =A0 =A0firmware loader: embed device into firmware_priv structure

This commit does introduce one possible double free, maybe is related with
the issue, please try the attachment patch to see if the oops can be fixed.


--=20
Lei Ming

--0016363ba1f8cb84cb048e419f25
Content-Type: application/octet-stream; 
	name="fix_possible_double_free.patch"
Content-Disposition: attachment; filename="fix_possible_double_free.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gd33m9g30

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmFzZS9maXJtd2FyZV9jbGFzcy5jIGIvZHJpdmVycy9iYXNl
L2Zpcm13YXJlX2NsYXNzLmMKaW5kZXggYzhhNDRmNS4uNDBhZjQzZSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9iYXNlL2Zpcm13YXJlX2NsYXNzLmMKKysrIGIvZHJpdmVycy9iYXNlL2Zpcm13YXJlX2Ns
YXNzLmMKQEAgLTU2OCw3ICs1NjgsNyBAQCBzdGF0aWMgaW50IF9yZXF1ZXN0X2Zpcm13YXJlKGNv
bnN0IHN0cnVjdCBmaXJtd2FyZSAqKmZpcm13YXJlX3AsCiBvdXQ6CiAJaWYgKHJldHZhbCkgewog
CQlyZWxlYXNlX2Zpcm13YXJlKGZpcm13YXJlKTsKLQkJZmlybXdhcmVfcCA9IE5VTEw7CisJCSpm
aXJtd2FyZV9wID0gTlVMTDsKIAl9CiAKIAlyZXR1cm4gcmV0dmFsOwo=
--0016363ba1f8cb84cb048e419f25--
