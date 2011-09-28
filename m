Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1I1RAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:00:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37735 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1I1RAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:00:06 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MX_OAAiuUZh-qFVLTJVGAp_jTS+d3Lc-T_E0XTj=xa=Zg@mail.gmail.com>
References: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
 <CACqU3MXzUbQS9fy0Etgt2GcgwRoXfihhmw-aWjrCFbzvmDM7yg@mail.gmail.com>
 <CA+55aFwKyd5fuyxu2tGDbQ8gKiEj=z7uYdBRg9O46WN0sTeNTQ@mail.gmail.com>
 <CACqU3MU8jkysNxFasdfy9ksqSo2ojiZ5LUwfcfX13MMRgVx2Xw@mail.gmail.com>
 <CACqU3MWyCknNH3xmVmbJJu+w9ugNc3e4K3e3_6cY1RAy4ynJCQ@mail.gmail.com>
 <CA+55aFxp8bNhLs+v69gp7XxBGq6wkmLkZKjB2_09H3qsZC_pzw@mail.gmail.com>
 <CACqU3MUbiQW3E8GeSbzkikMqvV1VKAnF2Ro-P2BWwih=s6vABA@mail.gmail.com>
 <CA+55aFwf3iOwyDDxjKbJ0fs=fy+-8mkoFHdgsEq32nAkerXS4g@mail.gmail.com> <CACqU3MX_OAAiuUZh-qFVLTJVGAp_jTS+d3Lc-T_E0XTj=xa=Zg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Sep 2011 09:59:45 -0700
X-Google-Sender-Auth: ELriDmxLiBPBNunGjUkxK29gXac
Message-ID: <CA+55aFzrm4a_DZ0V4OQjCJYo7_7u9iTwS+2ssjqadPw1SgBLdQ@mail.gmail.com>
Subject: Re: Linux 3.1-rc7
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 9:38 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>
> At some point I did not trust the internal disk, but SMART tests
> (`short', `'long', `conveyance') passed successfully. I'd assume that
> a bad cable issue between the USB adapter and the disk would be caught
> by the UDMA_CRC_Error_Count counter (it already did), and would be
> somehow truly random. I'm not sure if USB do any kind of data checksum
> between the host and the device. I'd assume so.

I forget what the exact physical level rules are, I wouldn't really
expect all devices to necessarily even check the checksums. There's
some real crap out there.

Iirc, the common USB packet size is 512 bytes, so your corruption
pattern could match that "end of a packet" kind of rule (especially
with the header to specify where the write goes). I dunno. Hardware
problems can be a nasty nasty issue to debug.

                            Linus
