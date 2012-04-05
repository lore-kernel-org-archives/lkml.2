Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab2DEHqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 03:46:31 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52069 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2DEHqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 03:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <1333586419.23520.52.camel@joe2Laptop>
References: <1333569554.864.3.camel@mop> <1333583480.23520.37.camel@joe2Laptop>
 <20120405003321.GB27595@kroah.com> <1333586419.23520.52.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 5 Apr 2012 09:46:09 +0200
Message-ID: <CAPXgP11qdyccftPPA9LSRKVb-Xnf8BzP+deUmTzHnuVxoTQKog@mail.gmail.com>
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 02:40, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-04-04 at 17:33 -0700, Greg Kroah-Hartmann wrote:
>> On Wed, Apr 04, 2012 at 04:51:20PM -0700, Joe Perches wrote:
>> > On Wed, 2012-04-04 at 21:59 +0200, Kay Sievers wrote:
>> > > From: Kay Sievers <kay@vrfy.org>
>> > > Subject: printk: support structured and multi-facility log messages
>> > []
>> > > This patch extends printk() to be able to attach arbitrary key/value
>> > > pairs to logged messages,
>> > How does it do that?
>> The implementation doesn't show that?
>
> Not so far as I can tell.
>
> How are arbitrary key/value pairs attached
> in a printk?

There are 120 lines in the changelog, and a 100 lines large comment
block in the source code, and another 50 lines spread over the code,
and the hexdump examples in it, and all that? Even without looking at
a single line of code, it should be explained from different
viewpoints more than once.

>> > > - Records consume almost the same amount, sometimes less memory than
>> > >   the traditional byte stream buffer (if printk_time is enabled). The record
>> > >   header is 16 bytes long, plus some padding bytes at the end if needed.
>> > >   The byte-stream buffer needed 3 chars for the syslog prefix, 15 char for
>> > >   the timestamp and a newline.
>> >
>> > I suggest using lzo on the string portion.
>>
>> As the used overall size is pretty much the same, that doesn't really
>> seem necessary to me.
>
> As dmesg output would still exist, compression could reduce
> the size of the duplicated logged output buffers significantly.

There are no other or duplicated buffers than the primary log buffer,
which is exactly the same buffer as today's printk() uses. When this
buffer is exported, the data is converted to a stream on-the-fly, and
it's a feature, that such stream is human readable and not compressed
output. I don't think there is much justification for a compression
overhead and the problems it would introduce.

Kay
