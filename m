Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab1COPKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:10:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757561Ab1COPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:10:52 -0400
MIME-Version: 1.0
In-Reply-To: <4D7F2C11.907@orcon.net.nz>
References: <4D7F2C11.907@orcon.net.nz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Mar 2011 08:10:31 -0700
Message-ID: <AANLkTimRDH4S1QMN6f4AfKOe6ipPK6jm+g91nuBJYQJa@mail.gmail.com>
Subject: Re: Alpha no longer recognises certain partition tables (v2.6.38)
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        warns@pre-sense.de
Content-Type: multipart/mixed; boundary=005045017408792dc5049e86d511
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--005045017408792dc5049e86d511
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Mar 15, 2011 at 2:06 AM, Michael Cree <mcree@orcon.net.nz> wrote:
> v2.6.38 boot reports it can't recognise the partition table on the system
> disk on my Alpha and panics when it can't find the root device.
>
> It worked at v2.6.38-rc7.
>
> While I haven't done a bisect to fully verify I nevertheless suggest the
> following patch as the likely cause:
>
> 1eafbfe Fix corrupted OSF partition table parsing

That sounds likely. What does something like the attached do? In
particular, what's the printed-out value of the OSF npartitions thing?

Also, it's quite possible that we should raise the value of
MAX_OSF_PARTITIONS. If I checked it right, the d_partitions[] array
starts at byte offset 148 in the sector, and it's 16 bytes in size, so
there _could_ be up to 22 partitions there. The fact that we had
defined the 'struct disklabel' to only contain 8 partitions is I think
from documentation, not a technical "there can be only eight".

                                  Linus

--005045017408792dc5049e86d511
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glayldtp0

IGZzL3BhcnRpdGlvbnMvb3NmLmMgfCAgICA0ICsrLS0KIDEgZmlsZXMgY2hhbmdlZCwgMiBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3BhcnRpdGlvbnMvb3Nm
LmMgYi9mcy9wYXJ0aXRpb25zL29zZi5jCmluZGV4IGJlMDNhMGIuLmZjYWIyMDEgMTAwNjQ0Ci0t
LSBhL2ZzL3BhcnRpdGlvbnMvb3NmLmMKKysrIGIvZnMvcGFydGl0aW9ucy9vc2YuYwpAQCAtNjgs
OCArNjgsOCBAQCBpbnQgb3NmX3BhcnRpdGlvbihzdHJ1Y3QgcGFyc2VkX3BhcnRpdGlvbnMgKnN0
YXRlKQogCX0KIAlucGFydGl0aW9ucyA9IGxlMTZfdG9fY3B1KGxhYmVsLT5kX25wYXJ0aXRpb25z
KTsKIAlpZiAobnBhcnRpdGlvbnMgPiBNQVhfT1NGX1BBUlRJVElPTlMpIHsKLQkJcHV0X2Rldl9z
ZWN0b3Ioc2VjdCk7Ci0JCXJldHVybiAwOworCQlwcmludGsoIk9TRjogJXUgcGFydGl0aW9uc1xu
IiwgbnBhcnRpdGlvbnMpOworCQlucGFydGl0aW9ucyA9IE1BWF9PU0ZfUEFSVElUSU9OUzsKIAl9
CiAJZm9yIChpID0gMCA7IGkgPCBucGFydGl0aW9uczsgaSsrLCBwYXJ0aXRpb24rKykgewogCQlp
ZiAoc2xvdCA9PSBzdGF0ZS0+bGltaXQpCg==
--005045017408792dc5049e86d511--
